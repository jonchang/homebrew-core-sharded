class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/0.2.4.tar.gz"
  sha256 "ebb1964747da49b5360a908fd527f2f018c7cd153fd19dd8c8cd0d00ad816c4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f26dd48e459d346950cc90a89ba0ccde1c12e9dd7e392f7640154476a4cc2d13" => :catalina
    sha256 "6fe7b97fd1d8b574f5cc39a4689720173cacf26e9d4faed8c5fa701d7675db72" => :mojave
    sha256 "7ec75465cc2b0851c857d54ccb35879164706ebed995aa850cb98ab14a65703f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
