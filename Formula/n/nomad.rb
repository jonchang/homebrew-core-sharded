class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.8.6.tar.gz"
  sha256 "e69b447dcc2caeb3d5ecf904cf3c8f327a5185a84442ee4241a796d89f96e143"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e3fdf8eb03a0213946362cef98d43c459cf4a8afabf8a2c58d4add3d91983ee" => :mojave
    sha256 "77b67791b27ff952a586b859fd6f4188fb4c66aaec60160e1c7ed86df2d32f41" => :high_sierra
    sha256 "42a080be365146664319df94e2382f6379a96e1ac39510876e7cedb7c8a8374c" => :sierra
    sha256 "ad5f56803a2484df8bd3828965f941bbe5608904703b9d36e4122cde1b0f0c36" => :el_capitan
  end

  depends_on "go@1.10" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/nomad").install buildpath.children
    cd "src/github.com/hashicorp/nomad" do
      system "go", "build", "-tags", "ui", "-o", bin/"nomad"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 10
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
