class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.7.0.tar.gz"
  sha256 "9cfb6be335f7a06ccaf7cc2a06075a23ed6e2e2fdd6ea7fbc165a7d4a30990f9"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc92b88a9b8f3bd658d7e94852781b94c8454f96d880bd51bcf09a4bc42365d5" => :catalina
    sha256 "1bf554953bade08fd0d34e5c79286a20a3a4707d23f24f8416e702d3a853eee0" => :mojave
    sha256 "0a462f17a6f2c1fdab7fd605da8b24d1e30e83fdfd7834756f054d25460c1543" => :high_sierra
  end

  depends_on "rust" => :build

  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--features", "stable", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "\n~ \n❯ 2\n\n~ \n❯ ", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')
  end
end
