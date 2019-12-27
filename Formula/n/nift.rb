class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v1.17.tar.gz"
  sha256 "cdcc3b54d9d98c70a95e14396d09588017fdb2ecfcc821a96778251577b9bafe"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init"
      assert_predicate testpath/"empty/site/index.html", :exist?
    end
  end
end
