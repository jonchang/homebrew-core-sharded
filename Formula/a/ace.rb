class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "http://download.dre.vanderbilt.edu/previous_versions/ACE-6.4.0.tar.bz2"
  sha256 "6a7fd5f23f6a004bb21978767df4e36adea078cd344e45bab50266213586c001"
  revision 1

  bottle do
    cellar :any
    sha256 "d3fb63e3d1e4408283e7547dfd409bdba157e2d3e62ba1b3066ed3ed10533576" => :sierra
    sha256 "316275bf43b05b13a96a7a30105dc3c64cc34bf8d437e77238e3922ceddacb5b" => :el_capitan
    sha256 "b865dc9968a6a29cc1c9e1f87a4a08560bdd8ee2e59db53732e3e4a7ea8f94f7" => :yosemite
  end

  # this patch backports new files for macOS Sierra and possibility to compile with Xcode 8 on El Capitan
  patch :DATA

  def install
    # Figure out the names of the header and makefile for this version
    # of OSX and link those files to the standard names.
    name = MacOS.cat.to_s.delete "_"
    ln_sf "config-macosx-#{name}.h", "ace/config.h"
    ln_sf "platform_macosx_#{name}.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end

__END__

diff --git a/ace/config-macosx-sierra.h b/ace/config-macosx-sierra.h
new file mode 100644
index 0000000..7cad7ce
--- /dev/null
+++ b/ace/config-macosx-sierra.h
@@ -0,0 +1,6 @@
+#ifndef ACE_CONFIG_MACOSX_SIERRA_H
+#define ACE_CONFIG_MACOSX_SIERRA_H
+
+#include "ace/config-macosx-elcapitan.h"
+
+#endif // ACE_CONFIG_MACOSX_SIERRA_H
diff --git a/include/makeinclude/platform_macosx_sierra.GNU b/include/makeinclude/platform_macosx_sierra.GNU
new file mode 100644
index 0000000..2ed4cc3
--- /dev/null
+++ b/include/makeinclude/platform_macosx_sierra.GNU
@@ -0,0 +1,3 @@
+
+include $(ACE_ROOT)/include/makeinclude/platform_macosx_elcapitan.GNU
+

diff --git a/ace/config-macosx-leopard.h b/ace/config-macosx-leopard.h
index 1b9b90d..cadb1a2 100644
--- a/ace/config-macosx-leopard.h
+++ b/ace/config-macosx-leopard.h
@@ -4,6 +4,8 @@
 #ifndef ACE_CONFIG_MACOSX_LEOPARD_H
 #define ACE_CONFIG_MACOSX_LEOPARD_H

+#include <Availability.h>
+
 #define ACE_HAS_MAC_OSX
 #define ACE_HAS_NET_IF_DL_H

@@ -205,9 +207,11 @@
 #endif

 #define ACE_LACKS_CONDATTR_SETCLOCK
+#if __MAC_OS_X_VERSION_MAX_ALLOWED < 101200
 #define ACE_LACKS_CLOCKID_T
 #define ACE_LACKS_CLOCK_MONOTONIC
 #define ACE_LACKS_CLOCK_REALTIME
+#endif
