class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.42.tar.xz"
  sha256 "a5f7471d766a71c222374efa4aa17ef6ee0e42ad48d15528edd935d1f0f6cd4d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0f9ea71e567da470344475a361e294ac08abb30c3d7accf802e224fbe9caf4c7" => :big_sur
    sha256 "fd422c49a76b2d474a474357aa44c2340f109b9309d4045698d2be1a94d37775" => :catalina
    sha256 "79a2da8c50a7d3cec1ed463d98b97a46a497f7b2a8b52d4ea99f7a460d0c47fd" => :mojave
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 800
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre"

  fails_with :clang do
    build 800
    cause "error: no matching constructor for initialization of 'value_type'"
  end

  # remove in next release
  # commit reference, https://github.com/MusicPlayerDaemon/ncmpc/commit/1a45eab
  patch :DATA

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dcolors=false", "-Dnls=disabled", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end

__END__
diff --git a/src/screen_utils.cxx b/src/screen_utils.cxx
index 95de70e..e85061f 100644
--- a/src/screen_utils.cxx
+++ b/src/screen_utils.cxx
@@ -29,6 +29,7 @@

 #ifndef _WIN32
 #include "WaitUserInput.hxx"
+#include <cerrno>
 #endif

 #include <string.h>
diff --git a/src/signals.cxx b/src/signals.cxx
index 4c005aa..9f3eb72 100644
--- a/src/signals.cxx
+++ b/src/signals.cxx
@@ -17,6 +17,7 @@
  * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */

+#include <signal.h>
 #include "Instance.hxx"

 void
