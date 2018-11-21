class Shc < Formula
  desc "Shell Script Compiler"
  homepage "https://neurobin.github.io/shc"
  url "https://github.com/neurobin/shc/archive/4.0.1.tar.gz"
  sha256 "494666df8b28069a7d73b89f79919bdc04e929a176746c98c3544a639978ba52"
  head "https://github.com/neurobin/shc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89d2e23222cb8e48c358d24eb400ef08c2007e29107463c48e9923fd258e5523" => :mojave
    sha256 "fd94200427a2d6c8fa50a64f1296abcf72231adf0cffae817f01fcd8ff92d4f5" => :high_sierra
    sha256 "49113c7de3364b971fb63719b104e3bf79f3758045ee31aaff6c79fc7d377f7d" => :sierra
  end

  def install
    system "./configure"
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/sh
      echo hello
      exit 0
    EOS
    system bin/"shc", "-f", "test.sh", "-o", "test"
    assert_equal "hello", shell_output("./test").chomp
  end
end
