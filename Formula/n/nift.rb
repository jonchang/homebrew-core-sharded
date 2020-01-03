class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.0.tar.gz"
  sha256 "86736893617433e84c1adc1a664ef94ebca53eec77028c3bb5c8b1a10d8a4d1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "8353be0cfb0213a0f9dcbabca8218f8cff2821e4ed3c71c93cdca2bb9910cad0" => :catalina
    sha256 "f7aad455365dadd4886778ee0cfa72457934be7fa53c3ac59bbfaf7915611a07" => :mojave
    sha256 "8264a8f07d65370fad356c6ae0e792f449b4fa5e39b83072b3fb2904041c8348" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init-html"
      assert_predicate testpath/"empty/site/index.html", :exist?
    end
  end
end
