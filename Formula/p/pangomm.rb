class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.48/pangomm-2.48.0.tar.xz"
  sha256 "9e0ed474c33f8c2002ca9e2b61ca0d1f3d8e409e09e99f4d8c19eeafccf55b78"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "efb06bb056de6e880375293435bcf1e516faa7e411b8461f0160519a6ab46ba6" => :big_sur
    sha256 "643ed5e66d794ba18276bc516c76655765a9adbdbf5701942ff811936f95550c" => :catalina
    sha256 "f09fc33e309cf58d7f573dbce385ec8a39a12927d305e7243b5d79b9f39f6a1d" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS
    cairo = Formula["cairo"]
    cairomm = Formula["cairomm"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{cairomm.opt_include}/cairomm-1.16
      -I#{cairomm.opt_lib}/cairomm-1.16/include
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.68
      -I#{glibmm.opt_include}/glibmm-2.68
      -I#{glibmm.opt_lib}/giomm-2.68/include
      -I#{glibmm.opt_lib}/glibmm-2.68/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/pangomm-2.48
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-3.0
      -I#{libsigcxx.opt_lib}/sigc++-3.0/include
      -I#{lib}/pangomm-2.48/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -L#{cairo.opt_lib}
      -L#{cairomm.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -lcairo
      -lcairomm-1.16
      -lglib-2.0
      -lglibmm-2.68
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lpangomm-2.48
      -lsigc-3.0
    ]
    on_macos do
      flags << "-lintl"
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
