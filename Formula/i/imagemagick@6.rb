class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406--6.9.10-12.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.10-12.tar.xz"
  sha256 "54549fe394598f6a7cec8cb5adc45d5d65b8b4f043745c6610693618b1372966"
  revision 1
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "6c85cb939742c9f26accce54d4d9ac4f1a830f9afa2686c06546fd537fcf24a9" => :mojave
    sha256 "d7413052972e2630d2ee0e55da4483bca8c3bcc52ed4f403abcee08df9411179" => :high_sierra
    sha256 "55c3d32afb612c2aa170dc94602b0fbd081faa77fb606540fafa4aca0edbeeec" => :sierra
  end

  keg_only :versioned_formula

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-perl", "Compile with PerlMagick"

  deprecated_option "enable-hdri" => "with-hdri"

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  depends_on "fftw" => :optional
  depends_on "fontconfig" => :optional
  depends_on "ghostscript" => :optional
  depends_on "liblqr" => :optional
  depends_on "librsvg" => :optional
  depends_on "libwmf" => :optional
  depends_on "little-cms" => :optional
  depends_on "openexr" => :optional
  depends_on "pango" => :optional
  depends_on "perl" => :optional

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
    ]

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--without-wmf" if build.without? "libwmf"

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
