class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "https://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.15.6.tar.gz"
  sha256 "55879b9da0f3756f3216f9fb857f35afb3b01294b5f18e0d1719334e7d4f5ac9"

  bottle do
    cellar :any_skip_relocation
    sha256 "22345f04357040cbb9ecdc49e242283b6a9f2afbe7cca1d99a11726f4594f726" => :catalina
    sha256 "22345f04357040cbb9ecdc49e242283b6a9f2afbe7cca1d99a11726f4594f726" => :mojave
    sha256 "22345f04357040cbb9ecdc49e242283b6a9f2afbe7cca1d99a11726f4594f726" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  uses_from_macos "expat"

  resource "protozero" do
    url "https://github.com/mapbox/protozero/archive/v1.6.8.tar.gz"
    sha256 "019a0f3789ad29d7e717cf2e0a7475b36dc180508867fb47e8c519885b431706"
  end

  def install
    resource("protozero").stage { libexec.install "include" }
    system "cmake", ".", "-DINSTALL_GDALCPP=ON",
                         "-DINSTALL_UTFCPP=ON",
                         "-DPROTOZERO_INCLUDE_DIR=#{libexec}/include",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <iostream>
      #include <osmium/io/xml_input.hpp>

      int main(int argc, char* argv[]) {
        osmium::io::File input_file{argv[1]};
        osmium::io::Reader reader{input_file};
        while (osmium::memory::Buffer buffer = reader.read()) {}
        reader.close();
      }
    EOS

    system ENV.cxx, "-std=c++11", "-stdlib=libc++", "-lexpat", "-o", "libosmium_read", "test.cpp"
    system "./libosmium_read", "test.osm"
  end
end
