class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.0.tar.bz2"
  sha256 "06bc932e00f13c95ef077a2eb61f64425534042cc50f86408b53c7615c4fe58b"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "7959929b5bc6059799909b9af6d222c2aba4744a8f78e344697dceb26fc3c485" => :catalina
    sha256 "24fe989bb5960ce4bb0900d3e29d4ebcaa68475e5953ca8173c55ebc8c2ce92e" => :mojave
    sha256 "4c197184d1d5ea6ca9d42994c971dca3f0d6e691811695c787c8794c659c6cb8" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if DevelopmentTools.clang_build_version == 600
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
