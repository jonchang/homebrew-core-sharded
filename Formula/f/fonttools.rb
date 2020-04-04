class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.7.0/fonttools-4.7.0.zip"
  sha256 "ce977f10f070752301e2d49ed822cfc860c881046d81c376fade1e6529b2046c"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a43260f8aac510308e691739ce3f865b8860f7500bbb1e039512066843bd1dc" => :catalina
    sha256 "4b83f5ed4d9d561bbef4e673a343992d533d9a61d8ff8785fcd69ed1bbb23ceb" => :mojave
    sha256 "59698c5ec9c6bb278ba905b84a19039fd91bb904a3dc6b2fee79c901ecd665cd" => :high_sierra
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
