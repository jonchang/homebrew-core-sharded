class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.1.1.tar.gz"
    sha256 "65d483bce244827de174edcb30f7e453b06a7590da6cdeb7a2237ff6180c090b"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.1.1.tar.gz"
      sha256 "89dbb7cad2a1cec1ca0cdaa0f0eafc5699676bcd6880891c7720a10dfe7f6af9"
    end
  end

  bottle do
    sha256 "6c6d62a96e916fd3640206508547e326e1d39e97a51c3abb36c7a921ed1c2e56" => :catalina
    sha256 "bf3ca399f4349eaefdf0435577c747e5adf10aaf881797d9eba5837dee80a92c" => :mojave
    sha256 "a79e3ee2648769f1d14b5f1c88e2f98154e3ea58355682018c8b6467c171d68b" => :high_sierra
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

    system "cmake", ".", *args
    system "make", "package"
    system "unzip", "minetest-*-osx.zip"
    prefix.install "minetest.app"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "#{prefix}/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end

  test do
    system "#{prefix}/minetest.app/Contents/MacOS/minetest", "--version"
  end
end
