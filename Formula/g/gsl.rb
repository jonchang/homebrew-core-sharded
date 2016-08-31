class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftpmirror.gnu.org/gsl/gsl-2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gsl/gsl-2.2.tar.gz"
  sha256 "4de40a9a79ea42a127928b095d066993cb845812d657434e29e987240113d8df"

  bottle do
    cellar :any
    revision 2
    sha256 "c9e21bb886a70e58470fc026b885d8fc929656389679f0b18f2073e630406e2a" => :el_capitan
    sha256 "15ce99a31e31584740852571f4f237195d21083f6675390dc50283429127400a" => :yosemite
    sha256 "06f9197561e1425ed56820dcab37bc64c35cfaa1b98a353b7fe9d4d220701bd1" => :mavericks
    sha256 "ab1f1a358a9307f81c0aea895d5ed69b7c20c24ab6d1673010f31f0d25f78ea2" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
