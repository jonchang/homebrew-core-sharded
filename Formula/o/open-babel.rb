class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-0-0.tar.gz"
  version "3.0.0"
  sha256 "5c630c4145abae9bb4ab6c56a940985acb6dadf3a8c3a8073d750512c0220f30"
  revision 1
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "7584694b0de308bfb6aa6cebd66e49bb6905942078051441164b2541e6f91b60" => :catalina
    sha256 "2f410442f5b6e43250b5d89e26bc2ca5d22103dcb74d70bc2b90a1ec568528e7" => :mojave
    sha256 "84a7ec2b7bf945d7baa10faeecabc627ac089cfef3b8493408012e1d17b0dc39" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
