class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://gitlab.kode54.net/kode54/vgmstream/repository/archive.zip?ref=r1040"
  version "r1040"
  sha256 "1f1ffb295138d02f01503b5eddd5c836811b7b02dca8a8cecc6a04b02ce9584a"
  head "https://gitlab.kode54.net/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "07ad639f6e945432b54af4fe9e3e88a7f35ac5a426203666e2f7187d8ed1f37c" => :sierra
    sha256 "8fedd0653375a376ec978739f24abc7a1dc24857a832be983ecd8978dd310043" => :el_capitan
    sha256 "314ab31528d85117117a4610a1f023b22686a565997357df92ceff52e4085013" => :yosemite
    sha256 "65522c757a6ce8392496e71279fa553074dc2b765d56a80b1709b58d1a56e704" => :mavericks
    sha256 "8e9771faf488616e96a159ee3d3681549f58ee240385c55f8a13be507e8a5a6a" => :mountain_lion
  end

  depends_on "mpg123"
  depends_on "libvorbis"

  def install
    cd "test" do
      system "make"
      bin.install "test" => "vgmstream"
      lib.install "../src/libvgmstream.a"
    end
  end
end
