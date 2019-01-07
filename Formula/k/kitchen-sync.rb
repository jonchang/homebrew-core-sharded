class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/1.9.tar.gz"
  sha256 "9e2dd1200a8bc0711bb69b9f0aa1e4aa6a3c0f7661f418f2b0db02fee0ec1059"
  revision 1
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    sha256 "e18c51dc84339926a8dc65858a37b11492b527037150fd741a7af199ad380f49" => :mojave
    sha256 "e4dd529bdecc3f5eb6424aac50e44ac1846600161280395c90da291a23c838dd" => :high_sierra
    sha256 "e649faa42de8df4272de7c48539d8ad8ceca1dcb7f8bfefbf3bedf761da06127" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  needs :cxx14

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
