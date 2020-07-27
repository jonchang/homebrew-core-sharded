class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.8.0.tar.gz"
  sha256 "7d0edf65f2ac7390af5e5a0b323b31202a6c11d744a74b588dc30f5a8c9865ba"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9479d4d551e9d1a65641770101eaabaf38b5b1b26f4dc91bbd1038de8b8e6daf" => :catalina
    sha256 "9479d4d551e9d1a65641770101eaabaf38b5b1b26f4dc91bbd1038de8b8e6daf" => :mojave
    sha256 "9479d4d551e9d1a65641770101eaabaf38b5b1b26f4dc91bbd1038de8b8e6daf" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~EOS
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    EOS
    assert_match std_output, shell_output("./test")
  end
end
