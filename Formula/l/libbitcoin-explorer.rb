class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.5.0.tar.gz"
  sha256 "630cffd577c0d10345b44ce8160f4604519b0ca69bf201f524f104c207b930aa"
  revision 2

  bottle do
    sha256 "aae3ff770f5857bac91474ddbb6f1e82e82839e61dc568b21332fc33545fb39e" => :high_sierra
    sha256 "57409051da543c57817a75d99448497b6e787e0d70c8ebccfcb5ca23b0750946" => :sierra
    sha256 "fe5cc5e3dad6720b60318a672d3baa37fc14ebf7efb14befdb407e06e2f3bb31" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "libbitcoin-client"
  depends_on "libbitcoin-network"
  depends_on "zeromq"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin-client"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    bash_completion.install "data/bx"
  end

  test do
    seed = "7aaa07602b34e49dd9fd13267dcc0f368effe0b4ce15d107"
    expected_private_key = "5b4e3cba38709f0d80aff509c1cc87eea9dad95bb34b09eb0ce3e8dbc083f962"
    expected_public_key = "023b899a380c81b35647fff5f7e1988c617fe8417a5485217e653cda80bc4670ef"
    expected_address = "1AxX5HyQi7diPVXUH2ji7x5k6jZTxbkxfW"

    private_key = shell_output("#{bin}/bx ec-new #{seed}").chomp
    assert_equal expected_private_key, private_key

    public_key = shell_output("#{bin}/bx ec-to-public #{private_key}").chomp
    assert_equal expected_public_key, public_key

    address = shell_output("#{bin}/bx ec-to-address #{public_key}").chomp
    assert_equal expected_address, address
  end
end
