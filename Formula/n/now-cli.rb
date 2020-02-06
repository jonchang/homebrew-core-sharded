require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-17.0.1.tgz"
  sha256 "12bf6a35c09593df9a8e02dac87fb1d03e86f3c166813e5e5dddf031ddc2f724"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1e4ca68d24122d99da6810667cab1ddf76df0f2141338c5139377d9ceb5820a" => :catalina
    sha256 "108b80dcca3e3a9b2791a477cedbef19096b05e628103ff9b16055203d8a5ee8" => :mojave
    sha256 "c9a83021623b33ef0c5f80f58d3abb60a79ec1a441d24a19da6d9cfd38560091" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
