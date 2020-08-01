class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.0.tar.gz"
  sha256 "8efb25d4831842788656736c4a2604208bd6bf8ff47912a0a2dd1174a096e9c5"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f3886b656696bffc4741079528e07b3e180067e805056b44fcd4d0281d1e17d" => :catalina
    sha256 "78dd8cefa702d07f612c6523019ec7bd96b4511daf324fd95a03e8f2f89c4849" => :mojave
    sha256 "8834f55c3a458f7503078849c7c0ba49f20dc824fc23ca64acad084d3e3dc1ec" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
