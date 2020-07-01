class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.14.tar.gz"
  sha256 "ead78ef55439f66f775757886ccce26cf741e9acbeb557dd6a4ee0e2f7c463ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "29e59d3cfc2dbf4abee96bc5733d6c6893d6acc45c53735b0ecdc65284034fc6" => :catalina
    sha256 "23678a783ff18f250a17881a01d0513061bfabbfe1c975ee2921a1414db34094" => :mojave
    sha256 "a0eefab02bbdb3aecae2564a5202f4f58a1703b99d3db136ecf3d0fe67cbc201" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", "-o", "#{bin}/#{name}", "-trimpath", "-ldflags", ldflags, "-tags", tags
  end

  test do
    touch "test.rb"
    system "echo | okteto init --overwrite --file test.yml"
    expected = <<~EOS
      name: #{Pathname.getwd.basename}
      image: okteto/ruby:2
      command:
      - bash
      workdir: /okteto
      forward:
      - 1234:1234
      - 8080:8080
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
