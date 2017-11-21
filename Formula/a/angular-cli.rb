require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.5.3.tgz"
  sha256 "165a66dd904d0842bf91e8576b77d7ee64e07c7e7fc2820df027adc433a2a689"

  bottle do
    sha256 "76570bdb22c91474582937140cec6975d7662f4e0b47fac0defdd63e0ff0de23" => :high_sierra
    sha256 "034df40172ef5402a89521e3e3a6638e6f7ee023694a8e4f7920cdd7c91b2f65" => :sierra
    sha256 "ba3d96622dd9d8d109b7069c679360ffb23adc4a0f345d885b1eeb51daac2c2e" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
