class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.19/proteinortho-v6.0.19.tar.gz"
  sha256 "e47ee8b2b960c890d59e4dabac24caddee6198eff122c56f507577c738d31c6c"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "0fcf6e8d97c506df8f11515c1b1612011a109a4193d8e0ebe8502ccc9318f61a" => :catalina
    sha256 "b4c0ff1c19c7b33e6734523c0366722e3c7f58e8b432d7f62fc326d0cffa9d5a" => :mojave
    sha256 "ae25e2ee3f4abee2b98cf274f60715e635a301867b852ab3c8c57bcf887cd615" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
