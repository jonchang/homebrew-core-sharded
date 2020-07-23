class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      :tag      => "v0.13.0",
      :revision => "808460a678d9c993d393c36e7eb06601a157efcf"
  license "GPL-3.0"
  head "https://github.com/dlang-community/dcd.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "1db1c37fa9dd757c4a91439bb36c8bbfae7983b9cfcaaa82b7cefcb6dfc5237e" => :mojave
    sha256 "932bb7fa259d950135a91973e7385e3fba9690cf899f65f0e1ffeb5b01d274e6" => :high_sierra
    sha256 "92cc0dcf3830b9b5fe63abe6d54323f8c310147f280be907123fa69b1646d868" => :sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = fork do
      exec "#{bin}/dcd-server", "-p", port.to_s
    end
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system "#{bin}/dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
