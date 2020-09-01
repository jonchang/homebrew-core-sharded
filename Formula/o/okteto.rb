class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.8.18.tar.gz"
  sha256 "a628d6c3fd8cef2b97b148f77bd3e697ac32be269fe4fe507394763e2cbf79a2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b6b919f6943ff34e86db866e1aaeb1d96508ac26200f48b15c9a012bf32998b" => :catalina
    sha256 "d750da8adb1b4142c902573e9432f3b20b8351fa749b096af5faf7dc93b52754" => :mojave
    sha256 "13ec8b59aca541fe59d7fad8502f2cc2263a825211ab96b7384e5a524e839518" => :high_sierra
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
      sync:
      - .:/okteto
      forward:
      - 1234:1234
      - 8080:8080
      persistentVolume: {}
    EOS
    got = File.read("test.yml")
    assert_equal expected, got
  end
end
