class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.6.6",
      revision: "4e6e7f49375d84bb35ee614c6b7d38b6c2fd3e7b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :catalina
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :mojave
    sha256 "34b2311deaff6b86a17bb7186cc5fac408afc55a3a385669b13d09367d231fe2" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = srcpath/"out/darwin_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
