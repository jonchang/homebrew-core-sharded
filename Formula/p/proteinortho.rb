class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.25/proteinortho-v6.0.25.tar.gz"
  sha256 "116272741291ded3d077ee06eba769e331c831439fceb5e1d2b11fe13425a231"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "9a32a3a922aa2d61e80220f679a55fa42d78f47ad1c11f6b6642056a2ec51051" => :big_sur
    sha256 "85814ae95c21c6597193c40e57ad037da666c758ababd18095595dacef2588ae" => :arm64_big_sur
    sha256 "91b3c79d33addde12fe369ace8af33c812b77afbf5e046e41d655ff9a99b54ea" => :catalina
    sha256 "52a33649857423332235f13dde88f9e27df37d0661fc4d80c9f64383937778e0" => :mojave
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
