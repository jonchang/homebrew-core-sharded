class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.19.1/pycairo-1.19.1.tar.gz"
  sha256 "2c143183280feb67f5beb4e543fd49990c28e7df427301ede04fc550d3562e84"

  bottle do
    cellar :any
    sha256 "66949ffd5a16c650e2d40538ea3ea3393d6bd2a742c6cb98775d12d6265c84ad" => :catalina
    sha256 "c94be03ec3bf0136f3a1a1efc5b42079906224e47326292c002fe996b8c1c729" => :mojave
    sha256 "c89298330de105cf366bbdeca8bb07f54e146f3b5f467a9f0e6eeba0a17a6680" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
