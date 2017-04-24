class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.12.0.tar.gz"
  sha256 "aa726e7da57eb4671ff19a198e7015c1899e0536b0152e7375a949c7216ef90c"

  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "6c17c6b07b7c34178d9f11311a1d4545c40d32d70111cae9d5f441c140f8f338" => :sierra
    sha256 "f67880ff41a81d63c87dca466441d695552bad6026249eef361a301e9badae91" => :el_capitan
    sha256 "9014132e29491f801da5f3fe223096d36326c63af3ad6801cd7376dc516bf5e1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
    system "./test"
  end
end
