class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.0.tar.gz"
  sha256 "945534d1f6bf99314085c16d2c13ec9d0fe75c8b3e88b83723858004c5e6e928"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "585991d883f69f8f05707c44ad65855c19348410bf45ac29bca5ba99ab793bd4" => :catalina
    sha256 "6b467a21218fed29a1f25c2269a573e819299499b46febc848aba9a0602f8883" => :mojave
    sha256 "7209b31831d096cabf8ed286cdcfb57cc2bc63fdf872527b00c3b787bf81cae7" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "Documentation/git-absorb.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"
  end
end
