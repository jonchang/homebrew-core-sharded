class MinimalRacket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/7.5/racket-minimal-7.5-src-builtpkgs.tgz"
  sha256 "232d53aef4233a1f50325da0e6455f84b77eb0829f8184e1219d0382c066073a"

  bottle do
    cellar :any
    sha256 "54682774edc9d7818bb3f13b24b782c351876c2f44573a1d5c0b042d1b17c5c9" => :mojave
    sha256 "b88127d2552cf2d11ade45f6e7deffd871cd27c1bf5937dae571dc8ba931c98b" => :high_sierra
    sha256 "e76979bfea6f2c0549e4393af622a6d73b174b6323320d253873022643bab4c2" => :sierra
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def install
    # configure racket's package tool (raco) to do the Right Thing
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace "etc/config.rktd", /\)\)\n$/, ") (default-scope . \"installation\"))\n"

    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-origtree=no
        --enable-macprefix
        --prefix=#{prefix}
        --mandir=#{man}
        --sysconfdir=#{etc}
      ]

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    This is a minimal Racket distribution.
    If you want to build the DrRacket IDE, you may run:
      raco pkg install --auto drracket

    The full Racket distribution is available as a cask:
      brew cask install racket
  EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $CHILD_STATUS.success?
    assert_match Regexp.new(<<~EOS), output
      ^name:
        #{version}
      catalogs:
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end
