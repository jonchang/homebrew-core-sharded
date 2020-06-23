class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.1.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.1.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.1.tar.gz"
  sha256 "95f2dd62979b500a99b34c1a6453a0787ada0330e4bec7fcffad37b9062d58d3"

  bottle do
    cellar :any
    sha256 "21895f23aed9113a620917e2eb1245a0b0391a5ac60c015961244a32d87af9b5" => :catalina
    sha256 "be472ad40b805c49164e72f8afaf08de36687431879549d107c8e9e8dc550ddc" => :mojave
    sha256 "6cc76004fca133f99d8eb7818d827ea5ac7fac6485bade98d9b7a3b0e3443fd3" => :high_sierra
  end

  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.1
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.1.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.1.tar.gz"
    sha256 "6e0233a3c2381bff36b91d791d0c16a9c362856c6baf70dbaa1c43049992e336"
    apply "patches/fileflags.diff",
          "patches/crtimes.diff"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    # SIMD code throws ICE or is outright unsupported due to lack of support for
    # function multiversioning on older verions of macOS
    args << "--disable-simd" if MacOS.version < :catalina

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "a"
    mkdir "b"

    ["foo\n", "bar\n", "baz\n"].map.with_index do |s, i|
      (testpath/"a/#{i + 1}.txt").write s
    end

    system bin/"rsync", "-artv", testpath/"a/", testpath/"b/"

    (1..3).each do |i|
      assert_equal (testpath/"a/#{i}.txt").read, (testpath/"b/#{i}.txt").read
    end
  end
end
