class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-20.03.1.tar.gz"
  sha256 "2a06fdf235276cf30c1fc5a64b0e0965e5bd843610d4dc599bf7c63c0ea985bb"
  head "https://github.com/wxMaxima-developers/wxmaxima.git"

  bottle do
    sha256 "bf250aac1701be4479a5134a9e0daf2695286e54557854be3848944c365b5024" => :catalina
    sha256 "e841aa552f522e7ca80fc01e6410f4660f70de4e85bd4194e54459e5915c2f03" => :mojave
    sha256 "baca78bfcf5a8253ef11f258704f13086bf44de0013bd420fe64339c5ea7d0bb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "wxmac"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    prefix.install "src/wxMaxima.app"
    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima"

    bash_completion.install "data/wxmaxima"
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end
