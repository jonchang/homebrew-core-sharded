# Major releases of erlang should typically start out as separate formula in
# Homebrew-versions, and only be merged to master when things like couchdb and
# elixir are compatible.
class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  revision 1

  head "https://github.com/erlang/otp.git"

  stable do
    # Download tarball from GitHub; it is served faster than the official tarball.
    url "https://github.com/erlang/otp/archive/OTP-19.0.2.tar.gz"
    sha256 "d0ec363d460994e63ef984c2367598990978ffe1d41bb0e0c25520a0ee1dab21"
  end

  bottle do
    cellar :any
    sha256 "8ae30608d2d7a2bcfd7107413602869f4998c5fd0d3974828fdc91f0fb18ded2" => :sierra
    sha256 "7e16bc2a67396455120f4e92b6017e049f51b1f42338242b7b65921a8df8b1cc" => :el_capitan
    sha256 "0e21ef732f6a871c9878fc4f36ef3d55c2ada95f440882a475936649539de38c" => :yosemite
  end

  option "without-hipe", "Disable building hipe; fails on various OS X systems"
  option "with-native-libs", "Enable native library compilation"
  option "with-dirty-schedulers", "Enable experimental dirty schedulers"
  option "with-java", "Build jinterface application"
  option "without-docs", "Do not install documentation"

  deprecated_option "disable-hipe" => "without-hipe"
  deprecated_option "no-docs" => "without-docs"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "fop" => :optional # enables building PDF docs
  depends_on java: :optional
  depends_on "wxmac" => :recommended # for GUI apps like observer

  fails_with :llvm

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_19.0.tar.gz"
    sha256 "c7a3d6d85a5a2b96d844297a3fa1bee448c3dd86237734688466249fd5a1401e"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_19.0.tar.gz"
    sha256 "b6f7c4e964673333f6c3eea8530dd988b41339b8912ae293f6f1b429489159ff"
  end

  def install
    # Fixes "dyld: Symbol not found: _clock_gettime"
    # Reported 17 Sep 2016 https://bugs.erlang.org/browse/ERL-256
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["erl_cv_clock_gettime_monotonic_default_resolution"] = "no"
      ENV["erl_cv_clock_gettime_monotonic_try_find_pthread_compatible"] = "no"
      ENV["erl_cv_clock_gettime_wall_default_resolution"] = "no"
    end

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    ENV["FOP"] = "#{HOMEBREW_PREFIX}/bin/fop" if build.with? "fop"

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--enable-native-libs" if build.with? "native-libs"
    args << "--enable-dirty-schedulers" if build.with? "dirty-schedulers"
    args << "--enable-wx" if build.with? "wxmac"

    if MacOS.version >= :snow_leopard && MacOS::CLT.installed?
      args << "--with-dynamic-trace=dtrace"
    end

    if build.without? "hipe"
      # HIPE doesn't strike me as that reliable on OS X
      # https://syntatic.wordpress.com/2008/06/12/macports-erlang-bus-error-due-to-mac-os-x-1053-update/
      # https://www.erlang.org/pipermail/erlang-patches/2008-September/000293.html
      args << "--disable-hipe"
    else
      args << "--enable-hipe"
    end

    if build.with? "java"
      args << "--with-javac"
    else
      args << "--without-javac"
    end

    system "./configure", *args
    # Install is not thread-safe; can try to create folder twice and fail
    # Reported 8 Sep 2016 https://bugs.erlang.org/browse/ERL-250
    ENV.deparallelize
    system "make"
    system "make", "install"

    if build.with? "docs"
      (lib/"erlang").install resource("man").files("man")
      doc.install resource("html")
    end
  end

  def caveats; <<-EOS.undent
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
