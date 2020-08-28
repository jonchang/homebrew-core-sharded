class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.5.tar.gz"
  sha256 "394768da33298ccab33512080fab93c022957af1b32f796fb7774f643dfb5fdb"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "747ff4bf00898a3364ec9ffcb5fce825d004db52fc82391ba77755f362a08deb" => :catalina
    sha256 "b409dfc345c6a1a362997dca8f50f73d5bcc81c5900cd443d119ab7bf6d1d46f" => :mojave
    sha256 "9a08f447d4895129c575df6e3491574417ff63c2308b498f61bc2f1327d9f16e" => :high_sierra
  end

  depends_on "go" => :build

  patch :p1 do
    url "https://github.com/lxc/lxd/commit/4a25da23b978d2eacb145d710a9682cc12b74f88.diff?full_index=1"
    sha256 "d3bd63cd2344e4ad2fc343cf85e8db0d80313f424eec0864a2d06786102b63ac"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
