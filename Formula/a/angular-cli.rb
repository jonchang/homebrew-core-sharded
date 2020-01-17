require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.23.tgz"
  sha256 "f5ce3bd724417ee858562ac4c6a7330a4b353261ee4769c857b9b3da4424f347"

  bottle do
    cellar :any_skip_relocation
    sha256 "10bef8838a2b951eded4c9474f3c682bcada804f9677779b1d1c46ee307ea4a9" => :catalina
    sha256 "4493e055be558a5400e6ad1451b4ef8e3f3fc988f68d76492b885a3858fba154" => :mojave
    sha256 "282293bd2bdb302df7284fd454b73929721dd3b2c0131802828bbe7021e54295" => :high_sierra
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
