class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.3.0.tar.gz"
  sha256 "7a6b8c6058fa887105dcd5f85b2808b2e0e7557f13b28d6fe802ce5609ff473e"

  bottle do
    cellar :any_skip_relocation
    sha256 "85b2472bc4724d5cc4ef11f1b8935e911c4b143ccf1c6b202d92400dd8349f7f" => :mojave
    sha256 "03791f8da7804f151509713f410cbb8fc7cbb0a44da1408fcbba90f4702ab9d5" => :high_sierra
    sha256 "8629112956e0c522c1b16a947e541757c1079ba4ce99e4aac3d0fdb0dd0eda60" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
