class Flint < Formula
  desc "C library for number theory"
  homepage "http://flintlib.org"
  url "http://flintlib.org/flint-2.6.1.tar.gz"
  sha256 "0d9dc2f3264e0c1d7c9b30fa058a14a3ac4d4ab01e95674c62966ea5aaafbf99"
  license "LGPL-2.1"
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    cellar :any
    sha256 "ca222082491f3251aeaadb567d690ea95969e8168ee04c635186d3a28cb276f5" => :catalina
    sha256 "4d6b8511625c7cd25964e1f63c4418e0dbcc2c0fc67350e4edbf7a345f1eb6a0" => :mojave
    sha256 "947f0abc0fa3342e1085ca9d78424b3f8beb2e5e172b7f2a49f946b4106842d3" => :high_sierra
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <stdlib.h>
      #include <stdio.h>

      #include <flint/flint.h>
      #include <flint/fmpz_mod_poly.h>

      int main(int argc, char* argv[])
      {
          fmpz_t n;
          fmpz_mod_poly_t x, y;

          fmpz_init_set_ui(n, 7);
          fmpz_mod_poly_init(x, n);
          fmpz_mod_poly_init(y, n);
          fmpz_mod_poly_set_coeff_ui(x, 3, 5);
          fmpz_mod_poly_set_coeff_ui(x, 0, 6);
          fmpz_mod_poly_sqr(y, x);
          fmpz_mod_poly_print(x); flint_printf("\\n");
          fmpz_mod_poly_print(y); flint_printf("\\n");
          fmpz_mod_poly_clear(x);
          fmpz_mod_poly_clear(y);
          fmpz_clear(n);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test"
  end
end
