class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.4.1/fonttools-4.4.1.zip"
  sha256 "fab07ad31b4d24d7b9798453f678faa179906d29a3ad15bddb92496f1f9ea122"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9759d192635405425da19b70ca494de3b2e4b32c5eac7091c99651d25fbab2ae" => :catalina
    sha256 "a77b259422c646a46a9f4157633e82d354c59437de0b546f71860332bacb7b52" => :mojave
    sha256 "bbe6390c7b202fbe0635e91a1d0df9de0a47d48237fd88eeb5f0043f3181508f" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
