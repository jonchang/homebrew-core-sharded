class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.3.tar.gz"
  sha256 "8cc0eaee73e646001c64adaab3e496ed20d4d729aaaf939df2a761e99c674372"

  bottle do
    cellar :any
    sha256 "d6ad29176f723fe1d80f243cf4ff7d359b42f9d29d70db44f621077a291c71d4" => :mojave
    sha256 "952d712f32b1a634ae941b924e912a01814bf0c62fc8a1756a641ac2540e36de" => :high_sierra
    sha256 "c7276a30037b10f781498c0eacebfa00adc217a3606756439d86c65cef4ccae7" => :sierra
  end

  depends_on "openssl"
  depends_on "readline"

  # patch for type conflict, sent upstream
  patch :p0, :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

__END__
--- xio-termios.h	2019-05-11 09:10:55.000000000 +0900
+++ xio-termios.h	2019-05-11 09:11:13.000000000 +0900
@@ -148,7 +148,7 @@
 extern int xiotermios_value(int fd, int word, tcflag_t mask, tcflag_t value);
 extern int xiotermios_char(int fd, int n, unsigned char c);
 #ifdef HAVE_TERMIOS_ISPEED
-extern int xiotermios_speed(int fd, int n, unsigned int speed);
+extern int xiotermios_speed(int fd, int n, speed_t speed);
 #endif
 extern int xiotermios_spec(int fd, int optcode);
 extern int xiotermios_flush(int fd);
