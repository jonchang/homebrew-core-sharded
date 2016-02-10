class Gimp < Formula
  desc "GNU Image Manipulation Program"
  homepage "http://www.gimp.org"

  stable do
    url "http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.16.tar.bz2"
    sha256 "95e3857bd0b5162cf8d1eda8c78b741eef968c3e3ac6c1195aaac2a4e2574fb7"
    depends_on "homebrew/versions/gegl02"
  end

  bottle do
    sha256 "f40f01ad2a8e276da71d95d4ea1435bd898e5a9bd6db8e1771e9bc32e411f3f5" => :el_capitan
    sha256 "06d11375198cd177456e3dcabe7d4599646b0f57a93e506ae339fa4690a0c10a" => :yosemite
    sha256 "697709f45c71405f3b98b0e21d0dbe2575beeac8c375ff96dd506aee86b0d0a9" => :mavericks
  end

  head do
    url "https://github.com/GNOME/gimp.git", :branch => "gimp-2-8"
    depends_on "gegl"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "babl"
  depends_on "fontconfig"
  depends_on "pango"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "cairo"
  depends_on "pygtk"
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "freetype"
  depends_on "xz" # For LZMA
  depends_on "d-bus"
  depends_on "aalib"
  depends_on "librsvg"
  depends_on "libpng" => :recommended
  depends_on "libwmf" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "ghostscript" => :optional
  depends_on "poppler" => :optional
  depends_on "libexif" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-glibtest
      --disable-gtktest
      --datarootdir=#{share}
      --sysconfdir=#{etc}
      --without-x
    ]

    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libpng" if build.without? "libpng"
    args << "--without-wmf" if build.without? "libwmf"
    args << "--without-poppler" if build.without? "poppler"
    args << "--without-libexif" if build.without? "libexif"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gimp", "--version"
  end
end
