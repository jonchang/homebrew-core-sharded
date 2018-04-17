class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero/archive/v0.11.1.0.tar.gz"
  sha256 "b5b48d3e5317c599e1499278580e9a6ba3afc3536f4064fcf7b20840066a509b"
  revision 2

  bottle do
    sha256 "d3e4de0f017590398dfe8eb9c551f533e6c3b2242deff80249d7ab58fc447612" => :high_sierra
    sha256 "dc7311d04f2f8a5eb01847c628d6e3691966bde8003a257fa3fbf71a4d14645d" => :sierra
    sha256 "1a19ec5435a0f8eaa5507a85508753d2349236117b110229d790daa7b50eb7f1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.60"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "readline"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).split[-1]
  end
end
