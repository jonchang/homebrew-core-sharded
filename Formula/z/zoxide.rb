class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https://github.com/ajeetdsouza/zoxide"
  url "https://github.com/ajeetdsouza/zoxide/archive/v0.4.1.tar.gz"
  sha256 "bf3bed2d384e2f137c1d4cf56a97fb7e925abd69823ce41f1552c76e183466c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "43b553c24f7ddf1eb33d85e11f4f1e3b8a015ebba506ecfb75c3a16b552f5e39" => :catalina
    sha256 "54ee00b69344542773764efa58bf4a970f1aab9ab3a2397172987b7ee904ff6b" => :mojave
    sha256 "645673cbcbbbc41f8255c0e70772821e702a324ac996c773b6df235a15a0e975" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "", shell_output("#{bin}/zoxide add /").strip
    assert_equal "/", shell_output("#{bin}/zoxide query").strip
  end
end
