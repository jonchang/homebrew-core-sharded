require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.4.tgz"
  sha256 "6cc369df89a7edcc600119b1dfb4495d2adde6269edbb7825e3e69d31befed50"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "235efa78d8ea21fe1620e699500fa80bf337fb7d12feebb8722418685427e7c9" => :catalina
    sha256 "ec61ea15f51c75a0eb7e25b9dc0ae1972bf5c07105162f61d1a9dc3335488332" => :mojave
    sha256 "968ff7a164a73fd77eddb5c78c5d980d79c17c7c2fd5bff3039520f8e59c3b35" => :high_sierra
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
