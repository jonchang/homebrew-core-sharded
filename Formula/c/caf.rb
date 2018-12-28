class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.16.3.tar.gz"
  sha256 "8596923b42dba6363d06bd053f179416ac96cdf3864e98a2ea78723a0a95a46f"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha256 "ada965dae932a57c2ac048dc7de4f7bfe4f7f891c85f1eb13bdccb7950247e18" => :mojave
    sha256 "31905277c00333e688d7a16e0e947496599b1d642e6dd2041aab94949490e251" => :high_sierra
    sha256 "cac351fa54d253d253aec01142e3b52c4dd6a827266c283c6fdf543f50848f75" => :sierra
  end

  depends_on "cmake" => :build

  needs :cxx11

  def install
    system "./configure", "--prefix=#{prefix}", "--no-examples",
                          "--build-static", "--no-opencl"
    system "make", "--directory=build"
    system "make", "--directory=build", "test"
    system "make", "--directory=build", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
        self->await_all_other_actors_done();
      }
      CAF_MAIN()
    EOS
    ENV.cxx11
    system *(ENV.cxx.split + %W[test.cpp -L#{lib} -lcaf_core -o test])
    system "./test"
  end
end
