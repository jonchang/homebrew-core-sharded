class GstPluginsBadAT010 < Formula
  homepage "http://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.bz2"
  sha256 "0eae7d1a1357ae8377fded6a1b42e663887beabe0e6cc336e2ef9ada42e11491"
  revision 1

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base@0.10"
  depends_on "openssl"

  # These optional dependencies are based on the intersection of
  # gst-plugins-bad-0.10.21/REQUIREMENTS and Homebrew formulae
  depends_on "dirac" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libmms" => :optional

  # These are not mentioned in REQUIREMENTS, but configure look for them
  depends_on "libexif" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "libsndfile" => :optional
  depends_on "schroedinger" => :optional
  depends_on "rtmpdump" => :optional

  def install
    ENV.append "CFLAGS", "-no-cpp-precomp -funroll-loops -fstrict-aliasing"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdl"
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer@0.10"].opt_bin/"gst-inspect-0.10"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
