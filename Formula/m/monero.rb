class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag      => "v0.13.0.2",
      :revision => "77ef8c1839e1984471605e072a20e04d1e7eb6f8"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "19c811c86459fb12196cc78476bdbc46ae03776b92c6918088b7bad0ea4ccb29" => :mojave
    sha256 "791392053b904200864ba338151f6bb0e1e6acc1b33dcfe11deda2620466c35b" => :high_sierra
    sha256 "3744abc5bf382888d465cc3d2f048f6db98c03b16426845a0c3aa9f0369e46ef" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libsodium"
  depends_on "openssl"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.2.3.tar.gz"
    sha256 "3e6b57bf49115f4ae893b1ff7848ead7267013087dc7be1ab27636a97144d373"
  end

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq",
                         "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"

    # Avoid conflicting with miniupnpc
    # Reported upstream 25 May 2018 https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
    rm_rf include/"miniupnpc"
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
