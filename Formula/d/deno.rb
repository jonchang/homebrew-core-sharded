class Deno < Formula
  desc "Command-line JavaScript / TypeScript engine"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v0.39.0/deno_src.tar.gz"
  sha256 "d2ed15722d7e114870979709bf1606e0da42ba5a3972c5838540b94909414efc"

  bottle do
    cellar :any_skip_relocation
    sha256 "4006e817ebad2c841a57690aadcdd1f0d18ad44257ec81656823f96d3d65046b" => :catalina
    sha256 "e8b528fa2002fbc34385331c3891db8ccac0474c31139930d84f1d0d0c56e903" => :mojave
    sha256 "d224a3b29b291ccea3fb0a6ed0fda61e0c45049b94f0b6fcd917fb140881ae4a" => :high_sierra
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build

  depends_on :xcode => ["10.0", :build] # required by v8 7.9+

  # Does not work with Python 3
  # https://github.com/denoland/deno/issues/2893
  uses_from_macos "python@2"
  uses_from_macos "xz"

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
      :revision => "fd3d768bcfd44a8d9639fe278581bd9851d0ce3a"
  end

  def install
    # Build gn from source (used as a build tool here)
    (buildpath/"gn").install resource("gn")
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out/", "gn"
    end

    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # overwrite Chromium minimum sdk version of 10.15
    ENV["FORCE_MAC_SDK_MIN"] = "10.13"
    # build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    cd "cli" do
      system "cargo", "install", "-vv", "--locked", "--root", prefix, "--path", "."
    end

    # Install bash and zsh completion
    output = Utils.popen_read("#{bin}/deno completions bash")
    (bash_completion/"deno").write output
    output = Utils.popen_read("#{bin}/deno completions zsh")
    (zsh_completion/"_deno").write output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
