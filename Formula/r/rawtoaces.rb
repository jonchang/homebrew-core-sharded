class Rawtoaces < Formula
  desc "Utility for converting RAW to ACES"
  homepage "https://github.com/ampas/rawtoaces"
  url "https://github.com/ampas/rawtoaces/archive/v1.0.tar.gz"
  sha256 "9d15e7e30c4fe97baedfdafb5fddf95534eee26392002b23e81649bbe6e501e9"
  license "AMPAS"
  revision 10

  bottle do
    sha256 "7df849270b754ff329d7e87c96f7338077269aea3a93244795982a61fcc0cdcc" => :catalina
    sha256 "da904eb39e7e7fc75b4524cc61975dbc70977d99de1aaf1730b8d9eed7ffe8a5" => :mojave
    sha256 "48128a9a74bd85f01a9b7026de2ac590b5f0f70e96849aa17311107a6e243f3f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "aces_container"
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "ilmbase"
  depends_on "libraw"

  # Fixes build with libraw 0.20.0
  # https://github.com/ampas/rawtoaces/pull/120
  patch do
    url "https://github.com/ampas/rawtoaces/commit/86d13a0b6d6a7058594258dfa6e1c5888d6a0b75.patch?full_index=1"
    sha256 "a0a897a6341783e7e4b4db117b37d54bd3197bb42e9c90b59dd74361137388d8"
  end

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Day-light (e.g., D60, D6025)", shell_output("#{bin}/rawtoaces --valid-illums").strip
  end
end
