class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.3.1.tar.gz"
  sha256 "549b2fe1b807256ec42a16fe5507b115fcd9c75a59a17de46dc3151ae28a1337"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd2ce552d9162dd66e94f0d075c8e14c8a49c57e1c3237c1d02eeed54c52b1bd" => :catalina
    sha256 "d4e3b6c42f5ce3a347d24d3325cd9710288faa211392eb05fb11cf41a0ac9be7" => :mojave
    sha256 "46aac690711be4d393b66b5e2bbfe09682dad3dafe97522ead75649122ac56e3" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
