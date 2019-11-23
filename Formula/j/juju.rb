class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.10/+download/juju-core_2.6.10.tar.gz"
  sha256 "d781b733dd7a4e74ef0e9f88527a74a4bea0298e56f4dcaa6dd1cf62c2c40f2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "b65c4001d14903681602f80a625576323fa9786d57d444400776b66bafa0a043" => :catalina
    sha256 "303e828a56d5c524bd42ce34231f85a2868a62fb7bee07e0eca44e35f4dc9495" => :mojave
    sha256 "ad7e93a9fe152bbcd614b2ccdc6887174f64a1db867b2dd6764f51399d88b2a9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # Fix for Catalina
    # Backport of https://github.com/juju/juju/pull/10775 and https://github.com/juju/os/pull/14
    # Remove in 2.7
    inreplace Dir["src/github.com/juju/juju/vendor/github.com/juju/{utils,os}/series/series.go"],
      "var macOSXSeries = map[int]string{",
      "var macOSXSeries = map[int]string{\n\t19: \"catalina\","

    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
