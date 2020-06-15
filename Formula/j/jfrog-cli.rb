class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.37.1.tar.gz"
  sha256 "8f40d56a20a26ad5f59e1b355c22b726ffeacc2dfceaa2b808e7258ff68e41df"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcdae99f6b81e7e5a42f0ff1a594ef9af5b32d9911bdb9f43346e51a309acfe9" => :catalina
    sha256 "71db1527b636ad2628a414847132f57d1c7356415f8621b176044fc886fc0d53" => :mojave
    sha256 "314c5e5c01aaf005e67ae6f69b011142fcab7acd7c740f1a3f73ad4368045085" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
