class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.0/libupnp-1.14.0.tar.bz2"
  sha256 "ecb23d4291968c8a7bdd4eb16fc2250dbacc16b354345a13342d67f571d35ceb"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "2343d98fde1cf6ff2cb529f08d609b9685e85e72cdb75916daf5fb21345c5baf" => :catalina
    sha256 "7d05f24f8bcb7e0edaaa35bce6f94208d05e9157c0b8897205bd0df84e9e845f" => :mojave
    sha256 "b67bb447214ba6622325b0b0932ae2366a7ea4d6b9342d723ec9c027515cadbc" => :high_sierra
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
