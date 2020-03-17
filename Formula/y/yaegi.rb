class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.0.tar.gz"
  sha256 "41f749fb2dfb49fe203d2cf4dcc5c4e77d0eed613f909292881da1c0e5cc8f55"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08df4e19c37dc9553c2e19e58354c5c982efda2fdb362af4d0a0eec59d0fa225" => :catalina
    sha256 "9bc40074557ae535aa34e700e11ed0dc5937fd9d198ef1fe0cf5bb3c63fd51af" => :mojave
    sha256 "fa209fb4890210bc4631c71edfa9aa218f01ab5d6bef2efb9202d4d666ae256f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"yaegi", "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "3 + 1", 0)
  end
end
