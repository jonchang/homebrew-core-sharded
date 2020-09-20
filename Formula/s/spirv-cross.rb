class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/2020-09-17.tar.gz"
  version "2020-09-17"
  sha256 "a3351742fe1fae9a15e91abbfb5314d96f5f77927ed07f55124d6df830ac97a7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e23ad5f26f55793c665977deecea85f7d1ac92a9f80bef9c86eaf8195709007a" => :catalina
    sha256 "33675bde9b1f2e5861d6c5b37f027ac9be2f9a1783d2efdc84f7756c483b085e" => :mojave
    sha256 "51295b9f28b4bff7807d938c741c7a0c5a807d22808dd84df97457bbcde9f621" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    # required for tests
    prefix.install "samples"
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath
    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", "spirv-cross"

    system "make"
  end
end
