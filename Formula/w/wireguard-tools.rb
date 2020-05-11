class WireguardTools < Formula
  desc "Tools for the WireGuard secure network tunnel"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-1.0.20200510.tar.xz"
  sha256 "cd526c7ea177e59ae4c0ebc4f3cc360b8524881b090d043426bdf7e3c85ac8e7"
  head "https://git.zx2c4.com/wireguard-tools", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "2a4f475a5e486d53927f300e8750e8140e0a0a29c79f09f9b892f417fed6378f" => :catalina
    sha256 "a6f1db3668b30d2438b1bb435ec76807f1ea0a861c1b87a4516a13388487260e" => :mojave
    sha256 "8cad1ffad53a3ddd4ceac6612f9f344c85ecefffa21b943408419c5ad66a8487" => :high_sierra
  end

  depends_on "bash"
  depends_on "wireguard-go"

  def install
    system "make", "BASHCOMPDIR=#{bash_completion}", "WITH_BASHCOMPLETION=yes", "WITH_WGQUICK=yes",
                   "WITH_SYSTEMDUNITS=no", "PREFIX=#{prefix}", "SYSCONFDIR=#{prefix}/etc",
                   "-C", "src", "install"
  end

  test do
    system "#{bin}/wg", "help"
  end
end
