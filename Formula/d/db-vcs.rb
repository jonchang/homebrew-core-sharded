class DbVcs < Formula
  desc "Version control for MySQL databases"
  homepage "https://github.com/infostreams/db"
  url "https://github.com/infostreams/db/archive/1.0.tar.gz"
  sha256 "a21f717ead07058242f28d90bd3d56f478f05039f0628e8f177c4383c36efefd"

  bottle :unneeded

  def install
    libexec.install "db"
    libexec.install "bin/"
    bin.install_symlink libexec/"db"
  end

  test do
    output = shell_output("#{bin}/db server add localhost", 2)
    assert_match "fatal: Not a db repository", output
  end
end
