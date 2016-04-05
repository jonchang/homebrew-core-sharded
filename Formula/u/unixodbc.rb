class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "https://downloads.sourceforge.net/project/unixodbc/unixODBC/2.3.4/unixODBC-2.3.4.tar.gz"
  mirror "ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-2.3.4.tar.gz"
  sha256 "2e1509a96bb18d248bf08ead0d74804957304ff7c6f8b2e5965309c632421e39"

  bottle do
    revision 1
    sha256 "a01d926f6ec2f5012ba73a895e9df1c381b9a5d08e73940c9dfc399071f4394f" => :el_capitan
    sha256 "550b019631e1aeb4db26949d35e0f199918c9da5d01713fc46e7d9429a590f35" => :yosemite
    sha256 "c9c239ea16774af35a3cddc1e5c6489b3c2b6c3072ab974c3449e89c0d24fbdb" => :mavericks
    sha256 "3e7288eb9bc4aa158fe84d535bca202f3df28d5f3e1c1e5a96f530b000eba073" => :mountain_lion
  end

  option :universal

  conflicts_with "virtuoso", :because => "Both install `isql` binaries."

  keg_only "Shadows system iODBC header files" if MacOS.version < :mavericks

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
