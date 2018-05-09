class Acpica < Formula
  desc "OS-independent implementation of the ACPI specification"
  homepage "https://www.acpica.org/"
  url "https://acpica.org/sites/acpica/files/acpica-unix-20180508.tar.gz"
  sha256 "2b81e45cb9cc5116e9bbb39f8822ff90ec44f9f2bf6fa87243e2cd7376c5f4d8"
  head "https://github.com/acpica/acpica.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06f1b2d023673650f79bbbf83061baf57f20901c0c8cb3bbae85fbccd2fa0e3d" => :high_sierra
    sha256 "1ed229be97752ca02fae5331ff4c5ec0c50da0ab757ad2c874aa952672dff96f" => :sierra
    sha256 "052846721833d17947375fe34b443d6ac0eb32f2b308b13038a9e071d94f9945" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/acpihelp", "-u"
  end
end
