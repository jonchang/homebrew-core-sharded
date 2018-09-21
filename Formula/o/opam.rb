class Opam < Formula
  desc "The OCaml package manager"
  homepage "https://opam.ocaml.org"
  url "https://github.com/ocaml/opam/releases/download/2.0.0/opam-full-2.0.0.tar.gz"
  sha256 "9dad4fcb4f53878c9daa6285d8456ccc671e21bfa71544d1f926fb8a63bfed25"
  head "https://github.com/ocaml/opam.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07f2777f0dda170b36e409a6db773a5aae0e202e812127b388a05afaa89b3949" => :mojave
    sha256 "b5e2621c1bca5f8374ee07ef878e5572e04debf9ba1d3aa4a2e16b8e26728e68" => :high_sierra
    sha256 "cd52d891272efc754a838e8a08a4a7c5030ff908430c3ed1303a549cd1a4f73d" => :sierra
    sha256 "74f8341302bb5a933276cff7f9dff7240ad59a4d968050674b63869d9963de7e" => :el_capitan
  end

  depends_on "ocaml" => [:build, :test]

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "lib-ext"
    system "make"
    system "make", "man"
    system "make", "install"

    bash_completion.install "src/state/shellscripts/complete.sh"
    zsh_completion.install "src/state/shellscripts/complete.zsh" => "_opam"
  end

  def caveats; <<~EOS
    OPAM uses ~/.opam by default for its package database, so you need to
    initialize it first by running:

    $  opam init
  EOS
  end

  test do
    system bin/"opam", "init", "--disable-sandboxing"
    system bin/"opam", "list"
  end
end
