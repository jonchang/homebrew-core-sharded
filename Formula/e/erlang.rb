class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.2.6.tar.gz"
  sha256 "4cf44ed12f657c309a2c00e7806f36f56a88e5b74de6814058796561f3842f66"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "3a55552ecd4f46ada8edc225a56afdc7ac91b9d1d351ebeebd0dc100fb37ced1" => :catalina
    sha256 "607873523a148e4fd795c38acd80a38cc82edcc1c7e3d6cbacdcd12636e4659f" => :mojave
    sha256 "4dfe81527ec3cb561a35fe2befbbf254765f0fb291ff8658d3d1169c9b5a4d80" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.2.tar.gz"
    sha256 "aad7e3795a44091aa33a460e3fdc94efe8757639caeba0b5ba7d79bd91c972b3"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.2.tar.gz"
    sha256 "09d41810d79fafde293feb48ebb249940eca6f9f5733abb235e37d06b8f482e3"
  end

  def install
    # Work around Xcode 11 clang bug
    # https://bitbucket.org/multicoreware/x265/issues/514/wrong-code-generated-on-macos-1015
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
