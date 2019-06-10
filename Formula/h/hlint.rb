require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-2.1.23/hlint-2.1.23.tar.gz"
  sha256 "12400517c248edfc6ae0088599c80f2e37b45c8796d638a4e75c7c6a9b125bc3"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "9b1db404b96fececf2ccc225070cc78e23fe8a168bc96f80c6fa176ae04c3029" => :mojave
    sha256 "d582bfd339b69a60b83831bbbe1a29fb483382cd8976746788b0f24860b348f1" => :high_sierra
    sha256 "a95a091ccfb902dc94a3a4a7db0df68baf2426168f9c815d07f0ecd634d14663" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
