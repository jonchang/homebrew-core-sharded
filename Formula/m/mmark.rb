class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.8.tar.gz"
  sha256 "40b60dec408da6cc74844006ab3677b3e6218e1efbe9840ee4e96f9adc2e2564"

  bottle do
    cellar :any_skip_relocation
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :catalina
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :mojave
    sha256 "35874a678154992f4c120de3a560d063935117ac1a8132c23efb91c5b8450cdd" => :high_sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/master/rfc/2100.md"
    sha256 "0b5383917a0fbc0d2a4ef009d6ccd787444ce2e80c1ea06088cb96269ecf11f0"
  end

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"mmark"
    man1.install "mmark.1"
    prefix.install_metafiles
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
