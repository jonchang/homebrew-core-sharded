class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.16.tar.xz"
  sha256 "3ef8580c5b86e32ca092ce8de43df204f5e6f714b0cd32bc6237e6cd0f34a8f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :catalina
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :mojave
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :high_sierra
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
