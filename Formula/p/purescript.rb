require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.5.tar.gz"
  sha256 "352c0c311710907d112e5d2745e7b152adc4d7b23aff3f069c463eceedddec17"
  head "https://github.com/purescript/purescript.git"

  bottle do
    revision 1
    sha256 "eb0c767c670a0c2667dce335f7c6779f217af76b74b9d2c7758bdbe5437be3e9" => :el_capitan
    sha256 "e310f8b86b303b509591f435cfe91b1e7edbd58cbdabe317eed748f817a630b8" => :yosemite
    sha256 "dccd44a886e5e8d8502fbc347399de854a1927607534c515a318e2e25a0e9b3a" => :mavericks
  end

  devel do
    url "https://github.com/purescript/purescript/archive/v0.9.0.tar.gz"
    sha256 "3c08582cacb909fbf2d2db7e7681afa14efd105d2e47ad93998377b273b853b8"
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
