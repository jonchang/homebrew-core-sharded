class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.tar.gz"
  sha256 "c0a7c8bacd0a3afbc19cffa096b68f28d7470efcb6797ec51a4fa369cadd79a4"

  bottle do
    sha256 "bbfe11f4eaa9f314e19f4d6ae905070a09c3c4bb98d405515b199afcad00422d" => :catalina
    sha256 "91044a389fcb01cc7173d0ff888998a9836e91320f3f6f55a1a3d663cb03f229" => :mojave
    sha256 "bd498b68beba699326bb17fb2e4c518060cba0376da4bda5954a3613dda8aa3f" => :high_sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
