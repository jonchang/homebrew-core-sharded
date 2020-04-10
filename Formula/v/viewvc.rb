class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.1/viewvc-1.2.1.tar.gz"
  sha256 "afbc2d35fc0469df90f5cc2e855a9e99865ae8c22bf21328cbafcb9578a23e49"

  bottle do
    cellar :any_skip_relocation
    sha256 "18ef8237be4eb2ad2578b31e21ad74f226bb7d4c92075474c92619547047a0f2" => :catalina
    sha256 "709c0f7f7badc7bce0b5e18edf1372a6c1ef3bfb01006d38a51d596a069fd516" => :mojave
    sha256 "709c0f7f7badc7bce0b5e18edf1372a6c1ef3bfb01006d38a51d596a069fd516" => :high_sierra
  end

  depends_on "subversion"
  depends_on :macos # Due to Python 2 (https://github.com/viewvc/viewvc/issues/138)

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?

      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    require "net/http"
    require "uri"

    begin
      pid = fork { exec "#{bin}/viewvc-standalone.py", "--port=9000" }
      sleep 2
      uri = URI.parse("http://127.0.0.1:9000/viewvc")
      Net::HTTP.get_response(uri) # First request always returns 400
      assert_equal "200", Net::HTTP.get_response(uri).code
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
