class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  url "https://www.clamav.net/downloads/production/clamav-0.101.4.tar.gz"
  sha256 "0bf094f0919d158a578421d66bc2569c8c8181233ba162bb51722f98c802bccd"

  bottle do
    sha256 "1bfc823aab8206ce16d3f3e61201e7b8858fc7c2d31702ada5f77607fad75911" => :mojave
    sha256 "6834591353a676f42c2920c5702c1b779f7bce2f0e8465e9b083b061142533df" => :high_sierra
    sha256 "1bf72a55fbe6e9ef362147f24a0f57a12adfbdd9f573e5a30e8c2279b8c3d8ff" => :sierra
  end

  head do
    url "https://github.com/Cisco-Talos/clamav-devel.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "yara"

  skip_clean "share/clamav"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --libdir=#{lib}
      --sysconfdir=#{etc}/clamav
      --disable-zlib-vcheck
      --enable-llvm=no
      --with-libjson=#{Formula["json-c"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-pcre=#{Formula["pcre"].opt_prefix}
      --with-zlib=#{MacOS.sdk_path_if_needed}/usr
    ]

    pkgshare.mkpath
    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    To finish installation & run clamav you will need to edit
    the example conf files at #{etc}/clamav/
  EOS
  end

  test do
    system "#{bin}/clamav-config", "--version"
  end
end
