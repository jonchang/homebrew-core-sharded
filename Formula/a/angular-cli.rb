require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.6.tgz"
  sha256 "465f36d5cf3dac122e7e7c74ce4a402fa9b5f3b38849a231d005e6b27a3aa6c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "db4d45ff52c0ee2ad0f16fc22b8b167b0383ab33926bead1bb9892ba135bc3f1" => :mojave
    sha256 "c857d598ff8684b7ec9f3ff0d8c312a5c5a303c80140e73d446c6a897936d9c3" => :high_sierra
    sha256 "a31d4dd2e62ba29e875682ba25652e9f39a743a67f692cd2ee4c1bd36ac3bff0" => :sierra
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
