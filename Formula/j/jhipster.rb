require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.7.0.tgz"
  sha256 "fdbdd81708d1299e60ab48af6ba8bdf4caa180a27db0d2f178939aaa1ecc04ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "2510bb4005bc92284bd036588bc9ede7a0cf64b386ec63a534de7708b8e2b868" => :catalina
    sha256 "5cdfbfd6ee6effb1f0c7530515200306a4615e5b3f5418dfe8032f0a8ff9b8be" => :mojave
    sha256 "09c208232217a5c1d7c11cb36ac547ca7c5be0cfec41adddf15fb4121fc974c4" => :high_sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
