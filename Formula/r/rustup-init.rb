class RustupInit < Formula
  desc "The Rust toolchain installer"
  homepage "https://github.com/rust-lang/rustup.rs"
  url "https://github.com/rust-lang/rustup.rs/archive/1.20.0.tar.gz"
  sha256 "f58381eb940353a7c78ec6c0f857d94175e207237437db369d6f0ada9c12e42a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d426342f4e3b4061805e8056ad25eff3b253740ba180f941137e5ca7c1df86bc" => :catalina
    sha256 "94cb5f24140351e20dc33fa9b62e55868fa5e0116ac2f446637f9cb77f8236d5" => :mojave
    sha256 "c107742debd703bdbcd6228f9d41221ed99cce07b904ccc3f638d40ed1235760" => :high_sierra
    sha256 "4120b388c7073eaab8825d4353932e1f8d6427139767eaa8c44ba959ed6d6a35" => :sierra
  end

  depends_on "rust" => :build

  def install
    cargo_home = buildpath/"cargo_home"
    cargo_home.mkpath
    ENV["CARGO_HOME"] = cargo_home

    system "cargo", "install", "--root", prefix, "--path", ".",
                    "--features", "no-self-update"
  end

  test do
    ENV["CARGO_HOME"] = testpath/".cargo"
    ENV["RUSTUP_HOME"] = testpath/".multirust"

    system bin/"rustup-init", "-y"
    (testpath/"hello.rs").write <<~EOS
      fn main() {
        println!("Hello World!");
      }
    EOS
    system testpath/".cargo/bin/rustc", "hello.rs"
    assert_equal "Hello World!", shell_output("./hello").chomp
  end
end
