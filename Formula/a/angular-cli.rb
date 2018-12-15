require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.1.3.tgz"
  sha256 "b685a610eb5bbe57ed693c441a4c47e2f7e1fb2bf04f6bfc7c98f14d17e0419b"

  bottle do
    sha256 "558dfb9f422171b784d3516a2b14a1d6a037ae7d9851ea663cfdb8b780fd7aef" => :mojave
    sha256 "d253b62d7ccdff8b2935c2aeda007d4d674faceebb77e529ae619ca73fbf4790" => :high_sierra
    sha256 "5d438c2b0519f3fa02572dbaf6de5bf427b0e7ab54d3e31dbbf826813ec1eaec" => :sierra
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
