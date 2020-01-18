class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.6.5.tar.gz"
  sha256 "f039e1b4c2e61e9a4cf99b843eed3e9ac65580079348f2799c2f8b70d09062f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "168f6cdbac21fa60c561d0c08b50301583a20fe9a7c5fa6c6597f6082ffbb894" => :catalina
    sha256 "888877d955331ba9978fee88307383713011c68b0cda11be406f09192796b772" => :mojave
    sha256 "4337279bdea0365592c50b8d2b2c0ef8da343d3db99e1c494cdf91a76410ef2d" => :high_sierra
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
      workdir: /usr/src/app
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
