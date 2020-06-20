class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.33.0/dhall-1.33.0.tar.gz"
  sha256 "61a2a4e1239a6982aa9a57a46f3a6d71fef680bc98f588875224c83fe7b0535a"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b7ae2830bf51400d2bdde97bcceb5e4992eedf229980da78d7a35c579450719" => :catalina
    sha256 "011d46243f0ba693aef55fead4190eef83ca383b57a5f3c3d5e7d8f81f321b97" => :mojave
    sha256 "52cd9b03bbcf41c92aee32d2bea4207df4bb65d0d289288f92329122b107805e" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
