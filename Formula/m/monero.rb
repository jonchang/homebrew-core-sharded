class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero/archive/v0.11.1.0.tar.gz"
  sha256 "b5b48d3e5317c599e1499278580e9a6ba3afc3536f4064fcf7b20840066a509b"
  revision 1

  bottle do
    sha256 "231da78ff54b02f7dee6b10373e80df3dad7affecf48f60d2f260b4e739105a6" => :high_sierra
    sha256 "d8177a9ca161e58a4407a14209db4b9ddfc6562431823f825990f2ba8f6bbd59" => :sierra
    sha256 "298c42523b43aae3d27f98eb617deab6f600738aa4aff4345e3de6feaf08a239" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
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
