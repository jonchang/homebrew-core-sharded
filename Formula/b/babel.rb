require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.1.0.tgz"
  sha256 "4bdf9954f05402825a0bf5fb0903f7146d9edf75e1b0479ed2aa70d636d044a4"

  bottle do
    sha256 "5e03035442ff70071de03101d64dec324d5eb95c368eb1dd669df5ef1150eab3" => :mojave
    sha256 "dd7ce2af3685152476a0a6fdda7dd4ae3f0d3fb53242591cee0ef9571ea7ba44" => :high_sierra
    sha256 "78cc76dc8759216c18a5dc9a1a9151b7011276f8380b815d87f8f7225eeb195f" => :sierra
    sha256 "37bee0976593bbf281d30f1ea955a7b40c58f5f52fc0dc091993cfbde84b28fe" => :el_capitan
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.1.0.tgz"
    sha256 "c7e92941eeeae09167fe765b8ade41059329feaac998cda4aa41fc010a60b807"
  end

  def install
    (buildpath/"node_modules/@babel/core").install resource("babel-core")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = resource("babel-core").version
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

    assert_equal version, resource("babel-core").version
  end
end
