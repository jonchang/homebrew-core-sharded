class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v0.9.5/libpointing-0.9.5.tar.gz"
  sha256 "53c5b34303a5d752adf9f3c0f01ec6f9ac063c9dfc65c4abead30352ed9d4b67"

  bottle do
    cellar :any
    sha256 "508851f535414314ee4bafce1d7fab45bf2b4cdeac6b60da38d0e6fc6af88d08" => :el_capitan
    sha256 "6e07e5912ecc7b91b8e61c098c06f5d4a1e4135a9eec072df67b6889610bfc7a" => :yosemite
    sha256 "40d3282e18c450f748ee4b06082e47d824b12b15df5465c58a5ed5b419ecb787" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pointing/pointing.h>
      #include <iostream>
      int main() {
        std::cout << LIBPOINTING_VER_STRING << " |" ;
        std::list<std::string> schemes = pointing::TransferFunction::schemes() ;
        for (std::list<std::string>::iterator i=schemes.begin(); i!=schemes.end(); ++i) {
          std::cout << " " << (*i) ;
        }
        std::cout << std::endl ;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-lpointing", "-o", "test"
    system "./test"
  end
end
