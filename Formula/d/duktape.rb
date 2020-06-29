class Duktape < Formula
  desc "Embeddable Javascript engine with compact footprint"
  homepage "https://duktape.org"
  url "https://github.com/svaarala/duktape/releases/download/v2.5.0/duktape-2.5.0.tar.xz"
  sha256 "83d411560a1cd36ea132bd81d8d9885efe9285c6bc6685c4b71e69a0c4329616"
  revision 1

  bottle do
    cellar :any
    sha256 "db21b00be3c76ede599684bedbee17f4821dbb64933cefae7cfbea551929d405" => :catalina
    sha256 "77188e6a3c739a0f81f531223f99aa7490fa82f5c7b33ca59d8f153caf770910" => :mojave
    sha256 "90408a129a8233ac1250325ed8e1fd68e1ff98f3f0d983d14f4185f596961ef4" => :high_sierra
  end

  def install
    inreplace "Makefile.sharedlibrary", /INSTALL_PREFIX\s*=.*$/, "INSTALL_PREFIX = #{prefix}"
    system "make", "-f", "Makefile.sharedlibrary", "install"
    system "make", "-f", "Makefile.cmdline"
    bin.install "duk"
  end

  test do
    (testpath/"test.js").write "console.log('Hello Homebrew!');"
    assert_equal "Hello Homebrew!", shell_output("#{bin}/duk test.js").strip

    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include "duktape.h"

      int main(int argc, char *argv[]) {
        duk_context *ctx = duk_create_heap_default();
        duk_eval_string(ctx, "1 + 2");
        printf("1 + 2 = %d\\n", (int) duk_get_int(ctx, -1));
        duk_destroy_heap(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.cc", "-o", "test", "-I#{include}", "-L#{lib}", "-lduktape"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "Duktape can add number"
  end
end
