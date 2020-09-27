class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.8.0.tgz"
  sha256 "c1c6316f337aef60b984818bd4e99a609e43a58e574bf42e1ecc5a74cea2c572"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "95820f2081bf8eecfd84c4ff917fd307fb4bf2068e335f9b5579aa65449f1f53" => :catalina
    sha256 "a0d892df0e74c38604feb28650e943282295833ba8ae09d33e4265eb22ac3cb1" => :mojave
    sha256 "031aba145116e659ea203cb42f8f9487e61a516e190341e6b37a5a9be5accca4" => :high_sierra
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
