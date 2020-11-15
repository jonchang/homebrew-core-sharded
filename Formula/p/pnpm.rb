class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.12.0.tgz"
  sha256 "98d3c8b2dac310cbf472d380942b032b7d1f2560d2bf9626feac6cefc0559986"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b5f680f21d7bbc3d8696262718099ffafed8fc48d57775650c0d1a82e2d23589" => :catalina
    sha256 "4410b7add86f149db5cb5d50ce9bdc392765fbd414c786b68102b91b36394da9" => :mojave
    sha256 "e1b8de8a4b1701d313e08d9c36b23fdd1d3036c0e75f7b4ed1712766328cf1c1" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
