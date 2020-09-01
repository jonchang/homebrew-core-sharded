require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.11.5.tgz"
  sha256 "0fdf1bbbf63368f06a1fd97ef8067f9fd27eb746ffea07f5c12133030767f0b1"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "3823028884c32087ac82203fe0c9335f00dcb1a4b91a8cc0fbf128eba1d88482" => :catalina
    sha256 "96ba8b759ba61a6724df9b8015104eb992bf1543591f57c0e4178864854aef49" => :mojave
    sha256 "b79721e92717534cf2b54a974d1dff694fd0c1c8a750a4b223654724018da228" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.11.5.tgz"
    sha256 "753dac0c168274369d18cb7c2d90326173aa15639aa843d81b29ca2ac64926e5"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
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
