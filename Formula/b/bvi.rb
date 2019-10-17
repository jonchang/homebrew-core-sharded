class Bvi < Formula
  desc "Vi-like binary file (hex) editor"
  homepage "https://bvi.sourceforge.io"
  url "https://downloads.sourceforge.net/bvi/bvi-1.4.1.src.tar.gz"
  sha256 "3035255ca79e0464567d255baa5544f7794e2b7eb791dcc60cc339cf1aa01e28"

  bottle do
    sha256 "b4a33584800f48793b982b66ff91d0eab55f92c60846be9870b87c702542ed52" => :catalina
    sha256 "0a8c034737e4b28d4f6c83f3ff222a797f4488503ed44b9b0df9d8966c19d9ac" => :mojave
    sha256 "832a212daacc98df05797371ff7fb6ff0bbe5b7ac824a430c04b2b7f04d0e1e7" => :high_sierra
    sha256 "f918f3425865c4b8df97c32cf700f631d2c19e285adf01cc6ceadd429f7d0bfb" => :sierra
    sha256 "47c35b91db7052ee938daa6ddd95e96d49982e8767a48a0821f054b543fedb7f" => :el_capitan
    sha256 "4b5a3bdfa1bf083bde13338fc8fc5a8027880b3e79611ad064e44fd2f4d7a4a0" => :yosemite
    sha256 "7ec90f6665011faa3f1715cf6cc855270a536993633d8a4600cdb0492db16686" => :mavericks
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bvi", "-c", "q"
  end
end
