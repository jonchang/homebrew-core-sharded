require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.1.tar.gz"
  sha256 "e0f06adf266f366d8ac847be979ca6db9f16b487f2b1d0d3a2d1db4d1a3e11ea"

  bottle do
    sha256 "2e516c0655c320852eba081edafc0e9c48a2504460a0e55c0aaaa3e813db9a45" => :el_capitan
    sha256 "62eea06fe495a030eec19f4e48dd4e56d9cc6e521a13eac77192c11d6edc7aaf" => :yosemite
    sha256 "060d3f316e9237c8f5b64166da1dae5e844a41fcb5d1fd05ae577dfed0fd746f" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<-EOS.undent
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
