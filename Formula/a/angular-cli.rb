require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.2.tgz"
  sha256 "d439c49b179a3da8c482ffe93b3b27a2b2ba78a9a2c2b373b5790c56ccbc27ae"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c01777b980bf6739d71c6bfd7e2444c28cbe3fc7bde1b57b4c36634a37fa0171" => :catalina
    sha256 "4d7ca54cf0c170f88be410605c9827149f65bf1b7f53126a5f9e98df7d36cdbd" => :mojave
    sha256 "afb046f236d10e37c541b8e87c202d9cdb770e074ddb26b7a4f7cf71d3389809" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
