class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://product-dist.ballerina.io/downloads/1.2.2/ballerina-1.2.2.zip"
  sha256 "8ca5993c8bc53056b2415acdc6a15f0ea64263e3cfaa17fb9f4febdaab9b67a9"
  revision 1

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/ballerina"

    bin.install "bin/ballerina"
    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
