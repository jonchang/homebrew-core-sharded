require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.4.9.tgz"
  sha256 "43945ed0d711a7c5df5acc929d13138d317572fd6a736d8eebfeab27698a0fce"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d42f1da101f2445dec79e1b359cdd98b1b3d9d9ebd0635d91b835fdd67bce5d" => :catalina
    sha256 "d0e926fc95226202d61ef3e52eacc41bb48ab84f98f74645199ec845b2a5b6cd" => :mojave
    sha256 "0dac3715ff6b02ea8c399b80f40dd4696b2a30c1e541e53a3b666bba2b7de36d" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
