require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.2.tgz"
  sha256 "d58c950d25189ba42ae71c14496259e62c99ea7666f2e8c1de035668961927bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cb33db458608066421d6547655e1a0b98c77474701b79ec56153d05a3d79302" => :high_sierra
    sha256 "3ef16ccda682f4d6ec8e03cebbb94bfa623aa7de2ec67f21ee7abeec1f4b41a3" => :sierra
    sha256 "1a164a53d834bb1db568694108160e679773841adb4bd6f15c197768d362e345" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
