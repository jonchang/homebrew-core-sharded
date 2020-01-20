class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "https://www.mlpack.org"
  url "https://mlpack.org/files/mlpack-3.2.2.tar.gz"
  sha256 "7aef8c27645c9358262fec9ebba380720a086789d6519d5d1034346412a52ad6"
  revision 1

  bottle do
    cellar :any
    sha256 "a17acc9c885bcc783b36174eec7f6679daa1453d79faf16fab1a872731a74a8c" => :catalina
    sha256 "44c51c47f81f5382d8e07f9049431d88bff41b8e1ce4ec1006d828f234067271" => :mojave
    sha256 "427afcb1af58c19e13c7f733f35ccf0f2f5127473b0162f3fdef4d8db03f4b31" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "armadillo"
  depends_on "boost"
  depends_on "ensmallen"
  depends_on "graphviz"

  resource "stb" do
    url "https://github.com/nothings/stb/archive/f67165c2bb2af3060ecae7d20d6f731173485ad0.tar.gz"
    sha256 "ad5d34b385494cf68c52fad5762d00181c0c6d4787988fc75f17295c3c726bf8"
  end

  def install
    resource("stb").stage do
      (include/"stb").install Dir["*.h"]
    end
    cmake_args = std_cmake_args + %W[
      -DDEBUG=OFF
      -DPROFILE=OFF
      -DDOWNLOAD_STB_IMAGE=OFF
      -DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}
      -DENSMALLEN_INCLUDE_DIR=#{Formula["ensmallen"].opt_include}
      -DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/libarmadillo.dylib
      -DSTB_IMAGE_INCLUDE_DIR=#{(include/"stb")}
    ]
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
    doc.install Dir["doc/*"]
    pkgshare.install "src/mlpack/tests" # Includes test data.
  end

  test do
    cd testpath do
      system "#{bin}/mlpack_knn",
        "-r", "#{pkgshare}/tests/data/GroupLensSmall.csv",
        "-n", "neighbors.csv",
        "-d", "distances.csv",
        "-k", "5", "-v"
    end

    (testpath / "test.cpp").write <<-EOS
      #include <mlpack/core.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
    EOS
    cxx_with_flags = ENV.cxx.split + ["test.cpp",
                                      "-std=c++11",
                                      "-I#{include}",
                                      "-I#{Formula["armadillo"].opt_lib}/libarmadillo",
                                      "-L#{lib}", "-lmlpack",
                                      "-o", "test"]
    system *cxx_with_flags
    system "./test", "--verbose"
  end
end
