require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.1.tgz"
  sha256 "a1708c976b161c1d7bee1cb0bec691d2ef6c2bfbe3bc9d1ac7847b7de4394915"

  bottle do
    sha256 "fc4703411ffb95088a080369d3b19c7ed56c16b4964936c77135f4f23c664cc6" => :catalina
    sha256 "f8fa14f291c66a300e6cf86edf8e33249a6827c3fd9271c5d1178f4054b5adf3" => :mojave
    sha256 "43e50650e30842f68cea2384ca37ed2c62a93f85f6aba3d5ac45fbda34e0c581" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
