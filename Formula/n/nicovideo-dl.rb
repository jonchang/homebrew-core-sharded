class NicovideoDl < Formula
  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"

  depends_on "python"

  def install
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
