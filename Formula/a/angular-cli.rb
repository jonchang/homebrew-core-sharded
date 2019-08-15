require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.2.2.tgz"
  sha256 "6021ee904985e7811b5d4daabd777f414f4ead43d38a93f4e2bc4bbb5079567f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9d92ee2092b9e498a4697cc24912cf2911924d2502f5e57898e3c96f4ded80" => :mojave
    sha256 "2da8d7ce7dfa4146bcd94515ae9f51cc3915edfc45da70b2234e9550ca460d07" => :high_sierra
    sha256 "4d5f6905c44eee2f5774790993f194d9cdba175b57bb7772e57a14bdcdd3c6ee" => :sierra
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
