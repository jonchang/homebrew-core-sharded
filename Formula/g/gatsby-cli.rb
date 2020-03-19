require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.12.tgz"
  sha256 "d0649b643fd786d8c48ad073bb352d3602d88f05a9d0f92fab04b68be0ea9aef"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e5b748b8a8461530e11958daf3a1c5a8fd8bb86f594c030d0e7af1dc6952fb5" => :catalina
    sha256 "55ccade38132314a415ec8d557048b42d1ad86af3b2b8777ba80f9c410fbd3be" => :mojave
    sha256 "dc215117f4fa819b452134149156ba1d4c4cedc21fca0903cb9ddc9d67731549" => :high_sierra
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
