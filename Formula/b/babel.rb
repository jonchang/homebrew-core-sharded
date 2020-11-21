require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.7.tgz"
  sha256 "e3a739f5384b9735c5395f7dfd41cdd8df09cc89204a68690e167a207ea561f4"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "677db4aed1515579276826747f9b309ba26950f95dc7e4dce00c91a0c2f5e0a3" => :big_sur
    sha256 "50693b4208694a6d5618dd714a200998e2f79981d90a62f8b7d3c3758e948991" => :catalina
    sha256 "1b3d79127b6d6911a32db24fc0ec2f10ae4b9724d719180df59eb3bbbc3afbae" => :mojave
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.7.tgz"
    sha256 "5a909c24e38fa2149d8d2afe483234590a7d4a46bc39953cfab5b66610e4a4d4"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
