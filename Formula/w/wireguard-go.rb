class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20200121.tar.xz"
  sha256 "d790697df58bcd1d890f126d8a4f0b9aa11ad6f847a692e9c638a4b7b0454c14"
  head "https://git.zx2c4.com/wireguard-go", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "ef82da1cb0b4ed12cdd26181f2ee7d59a585f9dd3905ed626eca31a828e27452" => :catalina
    sha256 "ecf6348b31bb79b7816d2307959bbf0d25f9418dc2b948b1cd67326a9536bf8a" => :mojave
    sha256 "e81afd2526eb4e55583ffa9c9a1a6de494fe9d955fcc190f81f8a34e33d89427" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "be utun", pipe_output("WG_PROCESS_FOREGROUND=1 #{bin}/wireguard-go notrealutun")
  end
end
