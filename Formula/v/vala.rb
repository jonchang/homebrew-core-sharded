class Vala < Formula
  desc "Compiler for the GObject type system"
  homepage "https://live.gnome.org/Vala"
  url "https://download.gnome.org/sources/vala/0.32/vala-0.32.1.tar.xz"
  sha256 "dd0d47e548a34cfb1e4b04149acd082a86414c49057ffb79902eb9a508a161a9"

  bottle do
    sha256 "b68681f676381035cdd85e944aa234f0566137bda514ec105477fbeed246a365" => :el_capitan
    sha256 "752fe91460002b335c35084f073d6e3f3666017f6b7dea9f728a828a0dde911e" => :yosemite
    sha256 "bf422cf5802d09413482943afac7cd0b7d19e2defa1955330acb11d644d61299" => :mavericks
  end

  depends_on "pkg-config" => :run
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" # Fails to compile as a single step
    system "make", "install"
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.vala"
    path.write <<-EOS
      void main () {
        print ("#{test_string}");
      }
    EOS
    valac_args = [
      # Build with debugging symbols.
      "-g",
      # Use Homebrew's default C compiler.
      "--cc=#{ENV.cc}",
      # Save generated C source code.
      "--save-temps",
      # Vala source code path.
      path.to_s,
    ]
    system "#{bin}/valac", *valac_args
    assert File.exist?(testpath/"hello.c")

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
