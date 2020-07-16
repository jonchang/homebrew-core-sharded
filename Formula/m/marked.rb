require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.1.0.tgz"
  sha256 "6817b49595f95b8cebe5ecd6e7ea1c3d57c334458653285f391edd9c0352a9f7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9202c583c6447cf7d8d9f460cba10c66840dcb1adca730fad1b4acadff81fb17" => :catalina
    sha256 "696faee9ba51edb9ed10f85fac1473c4db82969674768c02a94e434d6275374a" => :mojave
    sha256 "7f311a0a5ec8ca62308b4e8ad3403313621156d0079c3aff04c56670097a6236" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
