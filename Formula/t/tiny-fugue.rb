class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "http://tinyfugue.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"

  bottle do
    sha256 "4ed6867f50a84cea3d90669ca06e8e3b491ed6660c5502b2441a59df6ddc1574" => :el_capitan
    sha256 "0bbabdbbf0ac42e53275163c1beb337d0a269e23a6f285604e38a57bd592414f" => :yosemite
    sha256 "c8c7907e4068f38251aedc00aff4cf265720e0f42ec444c8e5d4921031ec3d7a" => :mavericks
  end

  conflicts_with "tee-clc", :because => "both install a `tf` binary"

  depends_on "libnet"
  depends_on "openssl"
  depends_on "pcre"

  # pcre deprecated pcre_info. Switch to HB pcre-8.31 and pcre_fullinfo.
  # Not reported upstream; project is in stasis since 2007.
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-getaddrinfo",
                          "--enable-termcap=ncurses"
    system "make", "install"
  end
end


__END__
--- a/src/malloc.c	2007-01-13 15:12:39.000000000 -0800
+++ b/src/malloc.c	2012-10-26 08:23:30.000000000 -0700
@@ -7,6 +7,7 @@
  ************************************************************************/
 static const char RCSid[] = "$Id: malloc.c,v 35004.22 2007/01/13 23:12:39 kkeys Exp $";
 
+#include "sys/types.h"
 #include "tfconfig.h"
 #include "port.h"
 #include "signals.h"
--- a/src/macro.c	2007-01-13 15:12:39.000000000 -0800
+++ b/src/macro.c	2012-10-26 08:15:31.000000000 -0700
@@ -893,7 +893,8 @@
     }
     spec->attr &= ~F_NONE;
     if (spec->nsubattr) {
-	int n = pcre_info(spec->trig.ri->re, NULL, NULL);
+	int n;
+	pcre_fullinfo(spec->trig.ri->re, NULL, PCRE_INFO_CAPTURECOUNT, &n);
 	for (i = 0; i < spec->nsubattr; i++) {
 	    spec->subattr[i].attr &= ~F_NONE;
 	    if (spec->subattr[i].subexp > n) {
--- a/src/pattern.c	2007-01-13 15:12:39.000000000 -0800
+++ b/src/pattern.c	2012-10-26 08:16:19.000000000 -0700
@@ -151,7 +151,7 @@
 	    emsg ? emsg : "unknown error");
 	goto tf_reg_compile_error;
     }
-    n = pcre_info(ri->re, NULL, NULL);
+    pcre_fullinfo(ri->re, NULL, PCRE_INFO_CAPTURECOUNT, &n);
     if (n < 0) goto tf_reg_compile_error;
     ri->ovecsize = 3 * (n + 1);
     ri->ovector = dmalloc(NULL, sizeof(int) * ri->ovecsize, file, line);
--- a/src/pattern.h	2007-01-13 15:12:39.000000000 -0800
+++ b/src/pattern.h	2012-10-26 08:17:54.000000000 -0700
@@ -10,7 +10,7 @@
 #ifndef PATTERN_H
 #define PATTERN_H
 
-#include "pcre-2.08/pcre.h"
+#include <pcre.h>
 
 typedef struct RegInfo {
     pcre *re;
