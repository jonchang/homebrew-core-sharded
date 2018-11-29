class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.8.tar.gz"
  sha256 "c28ba68cc95582e40819034a8b70c1c4e4de01a22b12f42c289a555eb530c788"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca0ec74c87a2ef9d29c109152b74782c7e2e65a97a792af7672ef488a31b3c6c" => :mojave
    sha256 "dd0cea163e60056a5e9a67ea70f75965ff1684123ff6240fe80dc4cdec6d1b7d" => :high_sierra
    sha256 "5eb1ece221eb03c148aa4fd794e1854e90b445f923a6f4b3b955c3e7af643eda" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
