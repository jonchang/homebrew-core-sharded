class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.1.2/fish-3.1.2.tar.gz"
  sha256 "d5b927203b5ca95da16f514969e2a91a537b2f75bec9b21a584c4cd1c7aa74ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0fe77f3abf382d4cf1b65677b44ae7283682d7c86f3b194de337b4835d9f6bc" => :catalina
    sha256 "d1a94c227b7c241d93619c4541195db26167333d6e3dc748422d0bb9cebe0bf2" => :mojave
    sha256 "5699fdcf95c4c70ec8e7cd7654009fafb3c72c5ac032fa308325831c222e9ad8" => :high_sierra
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "pcre2"

  uses_from_macos "ncurses"

  def install
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      -DSED=/usr/bin/sed
    ]
    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
