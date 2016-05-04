class Pastebinit < Formula
  desc "Send things to pastebin from the command-line"
  homepage "https://launchpad.net/pastebinit"
  url "https://launchpad.net/pastebinit/trunk/1.5/+download/pastebinit-1.5.tar.gz"
  sha256 "0d931dddb3744ed38aa2d319dd2d8a2f38a391011ff99db68ce7c83ab8f5b62f"

  bottle do
    cellar :any_skip_relocation
    sha256 "01a71bae720fbbd41e00f8d091bdd82c635ec5a0377d8551fef9b411d324d4d1" => :el_capitan
    sha256 "19a89cc21076e0f0c48e2c355ef07420255938bb1170c28c5cac26924c619e25" => :yosemite
    sha256 "691f4cf7eb32ea56ef0ea02f9f0a68660147236c7abcf3e06669779a0f1033a4" => :mavericks
  end

  depends_on "python3"
  depends_on "docbook2x" => :build

  def install
    inreplace "pastebinit", "/usr/bin/python3", Formula["python3"].opt_bin + "python3"
    inreplace "pastebinit", "/usr/local/etc/pastebin.d", etc + "pastebin.d"
    system "docbook2man", "pastebinit.xml"
    bin.install "pastebinit"
    cp_r "pastebin.d", etc
    man1.install "PASTEBINIT.1" => "pastebinit.1"
    libexec.install "po", "utils"
  end

  test do
    system "date | pastebinit"
  end
end
