class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.6.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.6.2.tar.xz"
  sha256 "4a164b5cc971b896ce976bf4b624fab7279e0729cf983a5135df7e4df0970f6e"
  version_scheme 1

  bottle do
    sha256 "38b9aad3a92818ffeb444b098f68dc5fff1f55941f800326640754f605b7a611" => :catalina
    sha256 "c8630dddc2c28e2ca81a331cfe7af3689a86276f301f7fec82a93f52da581fe9" => :mojave
    sha256 "ab1c129cec316d67552115431726781a7f4ae95c089a1829e96bc95a6dadcff3" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
