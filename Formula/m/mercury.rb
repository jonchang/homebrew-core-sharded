class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-20.06.tar.gz"
  sha256 "b9c6965d41af49b4218d2444440c4860630d6f50c18dc6f1f4f8374d114f79be"

  bottle do
    cellar :any
    sha256 "929bf01a6bb21f8eb21049c5f9204f732f8cef4352a9c35bf8a74dfea3ff68db" => :catalina
    sha256 "c789a13ab24a2d0fe87084611fe2329e69babed231ab71c8f7488dd196d9688b" => :mojave
    sha256 "6193c6ea63f456f66c9137945a4b333d7c1d4e7370bf2a333d38ac9fff7ebd7a" => :high_sierra
  end

  depends_on "openjdk"

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}"]

    system "./configure", *args

    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<~EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS

    system "#{bin}/mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system "#{bin}/mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
