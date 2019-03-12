class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.60/glib-networking-2.60.0.tar.xz"
  sha256 "9085edc77eae591fa43d62878c0428eb0abc564e14a985a26c0cf9392a319fe3"

  bottle do
    sha256 "5505deacdbf1387b122137293782d2268dfa42d25b895bd9ef2e62af04dc88c1" => :mojave
    sha256 "8e6472219ce0ef120b9ff9a2dfbcac8d1121d229d7e4092024ee190bdf042129" => :high_sierra
    sha256 "0750703a8b91af01014f9f1ed35b7d1a30cc38d65743517dc9dc1cd92b510901" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  link_overwrite "lib/gio/modules"

  # see https://gitlab.gnome.org/GNOME/glib-networking/merge_requests/31
  patch do
    url "https://gitlab.gnome.org/GNOME/glib-networking/commit/1133663788212a1b8060febf7cc0d30c7bc0ecc0.patch"
    sha256 "7e0081138e034804cad4dacc84a7aab962ef315b21bf6c39ce67b40e9699505d"
  end

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dlibproxy=disabled",
                      "-Dopenssl=disabled",
                      "-Dgnome_proxy=disabled",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"gio-querymodules", HOMEBREW_PREFIX/"lib/gio/modules"
  end

  test do
    (testpath/"gtls-test.c").write <<~EOS
      #include <gio/gio.h>
      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
