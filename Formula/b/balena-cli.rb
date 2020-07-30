require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # balena-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.10.0.tgz"
  sha256 "87c35b105d2f158862c1b891d49375296062db685db6a64ca2a039c942480553"
  license "Apache-2.0"

  bottle do
    sha256 "45c34601d6f850fe3e66b418ab53a627a31049acca1982cef16b10e2215758cc" => :catalina
    sha256 "5343d12792251fa8ebfb81d90774406416e144cfd7a3a0b975feff7cab068d61" => :mojave
    sha256 "a46aafea91b8add40f0f7624f1a204dd52f5634a5fa58ce24f3c8bde12b4d01e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
