class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.13.tar.gz"
  sha256 "52affa2cf74d6e10c4a70da2c7b9621f7de1cc8ae4380d110a37ffc249066452"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a097d4243624b45fe43e7307a7d25b8a23392e40172220f501e2c3219e5111b1" => :catalina
    sha256 "433f1df40951193974ed0b2e10b2f1493f0dc21839ac84ab2e9d538c92d17f0b" => :mojave
    sha256 "3896f6d35dfab60c83a3e66f6d79b6358f7656b1c25091d4d690ebeb4885f295" => :high_sierra
    sha256 "7cbb8df8ff8b4784f491a0fdcaf88fef425c20c0569343970941df5d3fd0bc46" => :sierra
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
