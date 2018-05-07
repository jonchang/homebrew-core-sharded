class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.46.0/meson-0.46.0.tar.gz"
  sha256 "b7df91b01a358a8facdbfa33596a47cda38a760435ab55e1985c0bff06a9cbf0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "090d95adb42b3119ca14e6528d203474d102ec93ea54d907f5574b0b1257713a" => :high_sierra
    sha256 "090d95adb42b3119ca14e6528d203474d102ec93ea54d907f5574b0b1257713a" => :sierra
    sha256 "090d95adb42b3119ca14e6528d203474d102ec93ea54d907f5574b0b1257713a" => :el_capitan
  end

  depends_on "python"
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
