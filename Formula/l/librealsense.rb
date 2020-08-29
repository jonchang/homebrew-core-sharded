class Librealsense < Formula
  desc "Intel RealSense D400 series and SR300 capture"
  homepage "https://github.com/IntelRealSense/librealsense"
  url "https://github.com/IntelRealSense/librealsense/archive/v2.38.1.tar.gz"
  sha256 "77524946ad6fbd672e74c95f4970462817264be882fd532125bc98069fe39f19"
  license "Apache-2.0"
  head "https://github.com/IntelRealSense/librealsense.git"

  livecheck do
    url "https://github.com/IntelRealSense/librealsense/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "2c3155bb264ca81934c23c5269a4438a1ec93e598a596c09f5fda318975f43a7" => :catalina
    sha256 "8947b72f95546297499d1a95b3fb90ff66b6e94ced6a0cf25ea43b5e6c102da1" => :mojave
    sha256 "c0a07a82ae815b5000380518497419f5e16b3f6763aa0b7b9a3a9c6fdcbee0ca" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glfw"
  depends_on "libusb"

  def install
    args = std_cmake_args
    args << "-DENABLE_CCACHE=OFF"

    system "cmake", ".", "-DBUILD_WITH_OPENMP=OFF", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librealsense2/rs.h>
      #include <stdio.h>
      int main()
      {
        printf(RS2_API_VERSION_STR);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
