class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.5.0.tar.gz"
  sha256 "c7e61d02bf6bde873bdf4696bf1b695e09d2d396fcaa05ff37942290d1b75c63"

  bottle do
    sha256 "fcd59b63a412cb4ff05f40c7357c2c2d8f08992ccd79de78fe2f33f9f356d437" => :catalina
    sha256 "7c573a0e50d44e6985af26e0db832e4d7ced2dc5b0d78ada29db1d0aa44a8067" => :mojave
    sha256 "ceccb3d1b8e180436cd2f68251ce06fab3ec6f0e976075eb8ff84752b8c500fb" => :high_sierra
  end

  depends_on "pkg-config" => :build

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras=m_ldapauth.cpp,m_ldapoper.cpp"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
