class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v11.0.0.tar.gz"
  sha256 "d7b02fafc6dc08a222ac49028acfc22ce9e5baa6a8a53b0c88a38c146bed276e"

  bottle do
    cellar :any_skip_relocation
    sha256 "388c06b1eef4cd2b56a09f25dee7f65ae4b2352908c492b81e27d5e0bde81209" => :catalina
    sha256 "3468fd2aca6a32dea9c0c5d30b87e1a2b3423850480b072df3928f7b58c01ac2" => :mojave
    sha256 "3a4825040c877f35311716f15546b49229ee4f87dab6a64cdf232ce78c473799" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                               "--features", "all"
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
