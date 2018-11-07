class Mmseqs2 < Formula
  desc "Software suite for very fast protein sequence search and clustering"
  homepage "https://mmseqs.org/"
  url "https://github.com/soedinglab/MMseqs2/archive/6-f5a1c.tar.gz"
  version "6-f5a1c"
  sha256 "41a7b3114a2f54796e0d4e423045ee1bc3372834f75c72956e5c9eda520db586"

  bottle do
    cellar :any
    sha256 "8db02bf960227746276cf0011fc40b9105b30ec05dcf2fb9a2507e5ca3419f83" => :mojave
    sha256 "08498f8a25d75e3d5b739cb880e4ad43e871485d8b510adb2840ffb27f0266b4" => :high_sierra
    sha256 "d0dccfee074cfee58e7e4f0995d10592ee130f68d59ae15ec507a0a853829db6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  cxxstdlib_check :skip

  fails_with :clang # needs OpenMP support

  resource "documentation" do
    url "https://github.com/soedinglab/MMseqs2.wiki.git",
        :revision => "d3607c7913e67c7bb553a8dff0cc66eeb3387506"
  end

  def install
    args = *std_cmake_args << "-DHAVE_TESTS=0" << "-DHAVE_MPI=0"
    args << "-DVERSION_OVERRIDE=#{version}"

    args << "-DHAVE_SSE4_1=1" if build.bottle?

    system "cmake", ".", *args
    system "make", "install"

    resource("documentation").stage { doc.install Dir["*"] }
    pkgshare.install "examples"
    bash_completion.install "util/bash-completion.sh" => "mmseqs.sh"
  end

  def caveats
    unless Hardware::CPU.sse4?
      "MMseqs2 requires at least SSE4.1 CPU instruction support. The binary will not work correctly."
    end
  end

  test do
    system "#{bin}/mmseqs", "createdb", "#{pkgshare}/examples/QUERY.fasta", "q"
    system "#{bin}/mmseqs", "cluster", "q", "res", "tmp", "-s", "1"
    assert_predicate testpath/"res", :exist?
    assert_predicate (testpath/"res").size, :positive?
    assert_predicate testpath/"res.index", :exist?
    assert_predicate (testpath/"res.index").size, :positive?
  end
end
