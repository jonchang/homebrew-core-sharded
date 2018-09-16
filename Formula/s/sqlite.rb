class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2018/sqlite-autoconf-3250000.tar.gz"
  version "3.25.0"
  sha256 "de1a93dfc1ea23d93ee85440fe4347d0b9cd936f25c29645ee0ee170d1307f71"

  bottle do
    cellar :any
    sha256 "e8f585ebf7392da621a9c02a2a3e0699b6fc37919bb7726d86acea46ee42a825" => :mojave
    sha256 "4d0bd588c5bfed64a198ad773714c66e46b6a8222fa82b347b0c300f99ffb91b" => :high_sierra
    sha256 "e446b76306db6c6a1f508ea96814bbfaf9801614b63a568294d20e6fa06a72a4" => :sierra
    sha256 "23c9552652b32c7060d0e756eb7368b84f824ed6653291d7de2817d20ec9394f" => :el_capitan
  end

  keg_only :provided_by_macos, "macOS provides an older sqlite3"

  option "with-fts", "Enable the FTS3 module"
  option "with-fts5", "Enable the FTS5 module (experimental)"
  option "with-functions", "Enable more math and string functions for SQL queries"
  option "with-json1", "Enable the JSON1 extension"

  depends_on "readline"

  resource "functions" do
    url "https://sqlite.org/contrib/download/extension-functions.c?get=25"
    version "2010-02-06"
    sha256 "991b40fe8b2799edc215f7260b890f14a833512c9d9896aa080891330ffe4052"
  end

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_FTS3_PARENTHESIS=1" if build.with? "fts"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_FTS5=1" if build.with? "fts5"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_JSON1=1" if build.with? "json1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
    ]

    system "./configure", *args
    system "make", "install"

    if build.with? "functions"
      buildpath.install resource("functions")
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "extension-functions.c",
                     "-o", "libsqlitefunctions.dylib",
                     *ENV.cflags.to_s.split
      lib.install "libsqlitefunctions.dylib"
    end
  end

  def caveats
    s = ""
    if build.with? "functions"
      s += <<~EOS
        Usage instructions for applications calling the sqlite3 API functions:

          In your application, call sqlite3_enable_load_extension(db,1) to
          allow loading external libraries.  Then load the library libsqlitefunctions
          using sqlite3_load_extension; the third argument should be 0.
          See https://sqlite.org/loadext.html.
          Select statements may now use these functions, as in
          SELECT cos(radians(inclination)) FROM satsum WHERE satnum = 25544;

        Usage instructions for the sqlite3 program:

          If the program is built so that loading extensions is permitted,
          the following will work:
           sqlite> SELECT load_extension('#{lib}/libsqlitefunctions.dylib');
           sqlite> select cos(radians(45));
           0.707106781186548
      EOS
    end

    user_history = "~/.sqlite_history"
    user_history_path = File.expand_path(user_history)
    if File.exist?(user_history_path) && File.read(user_history_path).include?("\\040")
      s += <<~EOS
        Homebrew has detected an existing SQLite history file that was created
        with the editline library. The current version of this formula is
        built with Readline. To back up and convert your history file so that
        it can be used with Readline, run:

          sed -i~ 's/\\\\040/ /g' #{user_history}

        before using the `sqlite` command-line tool again. Otherwise, your
        history will be lost.
      EOS
    end
    s
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
