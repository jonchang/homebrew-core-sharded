class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.24.4.tar.gz"
  sha256 "8241279e0301745dbb079d6e9c994b404e7c15c5a594316d94bdb5b5c2f48358"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d272b60ff36f7f3aebb5158046b2942760d6688eb02204b57b214d025be055ff" => :catalina
    sha256 "3d682499578b277c30a5c1b6e1e465387e57ad3f24af8ff006fca71309a5a9bd" => :mojave
    sha256 "33b9c351349db0a6f1ab105b1f7b2dda3da1677661ff1c71c7d375d7acf32c07" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
