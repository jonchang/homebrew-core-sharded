class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/Aaronepower/tokei"
  url "https://github.com/Aaronepower/tokei/archive/v7.0.2.tar.gz"
  sha256 "f0ab7b073928eb365d3658be2517cad5f9fb9cd91c5030373570cad3695a60ef"

  bottle do
    sha256 "3955b971c68a46c26e6433c9a71038961bf4facbdff7b86f82cae2046cedd5a2" => :high_sierra
    sha256 "a2a9f4b5b019bf1dca116c9f10e7ca6871f4e78d110d13edf6b46b7a61c43a88" => :sierra
    sha256 "4b271a5d3f85fcf29be673deb2271216f3574e336eb6e954c1611811e4210dc5" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/tokei"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
