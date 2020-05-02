class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.6.7.tar.gz"
  sha256 "526e66f7317cfaa9ea017ad0a83a5c2f8ae469f9c522eed989eb83f16342c72d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0660554b8262f432ea63aa1d1b9e59edbc5eec33c3009ecaae49b81a381037d" => :catalina
    sha256 "0787591f3afb9fa58fc78f20ae42281687b54d4d06e8c74f2dcf499123e4470a" => :mojave
    sha256 "a6d97617c06828a8b0a30c57b8b9693ed13a656be192485a783e6efb8690e86d" => :high_sierra
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
