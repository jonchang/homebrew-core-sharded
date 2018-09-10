class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/3.1.0.tar.gz"
  sha256 "aef5f528dab826b269b54766a4c2d179e361866c75717af529f91c56b4034665"
  head "https://github.com/google/double-conversion.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31ab13dc2ee0c0e6892dfec9f96647009c7dba5b607a1fe4659fd384b225ad8" => :mojave
    sha256 "a90962bc9b0d25bd4d1c69e8892af60ffa4c8c18efd5653265debdad1736996e" => :high_sierra
    sha256 "bb2a51610649c9f86c06adc2ae66764a42b66e4d95166d306b05dff35e91e422" => :sierra
    sha256 "30a844eb4530cbe35e05fefed118fe096bf34de61c536283e6a1845f2f087639" => :el_capitan
    sha256 "dae47f87d852b0df160efaa57b1d2b81f96f31a8a2526e478f073f7fd0fc0beb" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "dc-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
