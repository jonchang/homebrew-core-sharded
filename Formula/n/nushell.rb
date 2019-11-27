class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.6.0.tar.gz"
  sha256 "90cdd83410d23e32fd47457d227b00cb2c8f607ac38020360eea0e385b693707"
  head "https://github.com/nushell/nushell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe7d8bb7afc14616f3513d1d4cb2a615ebd2d63460d020f5d7d732e14ab6ae7a" => :catalina
    sha256 "2ebfe6d0b3364c8efa9f308a55724eeaceaa2d40e7a89d63ce6274a57ce8badf" => :mojave
    sha256 "b00815e1b2dee7798a79b357a1afc9c203cc49037d1da39051184ef9a1cf4f53" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # assert_equal "#{Dir.pwd}> 2\n#{Dir.pwd}> CTRL-D\n", pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar":2}\' | from-json | get bar | echo $it')

    # Remove the test below and return to the better one above if/when Nushell
    # reinstates the expected behavior for Ctrl+D (EOF)
    assert_match version.to_s, shell_output("#{bin}/nu --version")
  end
end
