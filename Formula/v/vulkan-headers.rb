class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.152.tar.gz"
  sha256 "0f6a43300a848c84d907e9bbcb67702cdee30961823cad89c4e8f909852cdbc2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b963f2fe043f8913b869ce5862343ddf7cc3df0b142d043e907e7571d31c92" => :catalina
    sha256 "33b963f2fe043f8913b869ce5862343ddf7cc3df0b142d043e907e7571d31c92" => :mojave
    sha256 "33b963f2fe043f8913b869ce5862343ddf7cc3df0b142d043e907e7571d31c92" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
