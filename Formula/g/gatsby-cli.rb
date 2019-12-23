require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.21.tgz"
  sha256 "a909d5371cfb8688a0644d47048c1add0b497e25d4be928114f24f3d1b25f8b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "6eb778377b3f75ede96adc6f2389ddbd857096bf083ac0c6f50ed635da6957aa" => :catalina
    sha256 "22b7827a590b42bbb61ecae007d8c69b46f5232cc29df1a7114a7e3679e767a3" => :mojave
    sha256 "391ecb7c4c653177c2113d28feff432774bd7c547816e03dc98dd6b997f76f70" => :high_sierra
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
