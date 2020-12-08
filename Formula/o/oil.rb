class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.5.tar.gz"
  sha256 "4286eebb190f020e5c2472a48b0aa16a5abecfbf60068d1d9ad57d694e3ffc0a"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "5e8473c5b00b281b1e0d4ad78def14dabc7d2e6c8d3746e3be71d39f1bbbbf97" => :big_sur
    sha256 "3c410f150716b4facfcdd1ad7e5e0bcbed71ca50f8171cacdf65cf1ad82ef2aa" => :catalina
    sha256 "107d9f64b0b71b8764b268bf6046587718aa6e90c07866fd5178065c15695383" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    script = 'path=$(pwd); echo -n "$path"'
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c '#{script}'")
    assert_match "name=val isn't allowed", shell_output("#{bin}/oil -c '#{script}' 2>&1", 2)
  end
end
