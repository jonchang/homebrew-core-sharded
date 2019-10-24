class Tundra < Formula
  desc "Code build system that tries to be fast for incremental builds"
  homepage "https://github.com/deplinenoise/tundra"
  url "https://github.com/deplinenoise/tundra/archive/v2.11.tar.gz"
  sha256 "004965754e87dcaeb31df757ba3c745b641d1331bbab10e6a96df428bf836c11"

  bottle do
    cellar :any_skip_relocation
    sha256 "db24a99fecb494c1a14ee6a372a31dedd3a78b004b9a8202e827c50e8e528794" => :catalina
    sha256 "c0df5e3c6bfc993677832251cb21126a752d9c568a523d0a46cd4aa6fc4bdb88" => :mojave
    sha256 "c38d5302a7ce1685ce37c2c4a1d7284458b58368d5e001b00acad133903a532e" => :high_sierra
    sha256 "c25a23cb0b88587aea2e31261965af6b71c792cd04cb6b2366b5c5af9df20046" => :sierra
  end

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.10.0.tar.gz"
    sha256 "9dc9157a9a1551ec7a7e43daea9a694a0bb5fb8bec81235d8a1e6ef64c716dcb"
  end

  def install
    (buildpath/"unittest/googletest").install resource("gtest")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      int main() {
        printf("Hello World\n");
        return 0;
      }
    EOS
    (testpath/"tundra.lua").write <<~'EOS'
      Build {
        Units = function()
          local test = Program {
            Name = "test",
            Sources = { "test.c" },
          }
          Default(test)
        end,
        Configs = {
          {
            Name = "macosx-clang",
            DefaultOnHost = "macosx",
            Tools = { "clang-osx" },
          },
        },
      }
    EOS
    system bin/"tundra2"
    system "./t2-output/macosx-clang-debug-default/test"
  end
end
