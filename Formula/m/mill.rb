class Mill < Formula
  desc "Scala build tool"
  homepage "https://www.lihaoyi.com/mill/"
  url "https://github.com/lihaoyi/mill/releases/download/0.1.4/0.1.4", :using => :nounzip
  sha256 "c8029d6aa19953cb1c78806c7d25a5c769fd8dd4a49863eeac805c1f09e4c516"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install Dir["*"].shift => "mill"
    chmod 0555, libexec/"mill"
    (bin/"mill").write_env_script libexec/"mill", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"build.sc").write <<~EOS
      import mill._
      import mill.scalalib._
      object foo extends ScalaModule {
        def scalaVersion = "2.12.4"
      }
    EOS
    output = shell_output("#{bin}/mill resolve __.compile")
    assert_equal "foo.compile", output.lines.last.chomp
  end
end
