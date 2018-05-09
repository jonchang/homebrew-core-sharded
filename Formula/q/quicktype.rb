require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-13.0.10.tgz"
  sha256 "e3781fbd3043b994182b8f03cdc733f3d864c9caf2f88e59866a9234b9e37aeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "c347c2d258f004e78a5b4269bd6d4db5bc06ee8abb443c31e8a2f8a86385db0f" => :high_sierra
    sha256 "ea5be51505e736d3a7afe49672aa7aafcaf02c3abb731abaa33e82d3a5822d27" => :sierra
    sha256 "f81f6a64c8a89706e94796cb7971b9aa9fb05dc79717070329a66ff8381036b7" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
