class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     :tag      => "0.5.0",
     :revision => "3be22875e27f220350d8ab5b13403d804acfd20b"
  head "https://github.com/arduino/arduino-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72c5f419d5c90eec86c00cd725219413ba20f8eadccfafc65fc5eb39d84c5c75" => :catalina
    sha256 "cdcab9bbfeed3e305f1238e89daab615cab346e7ba40c7c40e2636f8baf9c5d0" => :mojave
    sha256 "d30a97bb9f425ae34858b5cb79f9cedebf132eaa25f9044f5c159bbc5c4778e6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    commit = Utils.popen_read("git", "rev-parse", "HEAD").chomp
    system "go", "build", "-ldflags", "-s -w -X github.com/arduino/arduino-cli/version.versionString=#{version} -X github.com/arduino/arduino-cli/version.commit=#{commit}", "-o", bin/"arduino-cli"
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/Documents/Arduino/test_sketch")
  end
end
