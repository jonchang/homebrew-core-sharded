class Openssl < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.0.2f.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2f.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.0.2f.tar.gz"
  sha256 "932b4ee4def2b434f85435d9e3e19ca8ba99ce9a065a61524b429a9d5e9b2e9c"

  bottle do
    sha256 "ed8aab358427f6456f99b59dc04667fd5dada7a4bd60eb0a2ce40c20ed6c125c" => :el_capitan
    sha256 "23a4c64aef59d211a4de12cd72c6109d96822065b1743f6db3cb45d623891989" => :yosemite
    sha256 "a46133fb0a514504984083e34b3c65c9b770ce2ceb543e013e55be891ac68434" => :mavericks
  end

  # 1.0.2f: fix typo in macro BIO_get_conn_int_port()
  # https://github.com/openssl/openssl/issues/595
  # https://github.com/openssl/openssl/pull/596
  patch do
    url "https://github.com/openssl/openssl/commit/da7947e8c6915d86616425ecbc4906f079ef122f.diff"
    sha256 "00bc58f9949baf592fb0caf63cd754f5407453cc4b61a1accb89040fa17b05b9"
  end

  # 1.0.2f: fix a typo in constant value DH_CHECK_PUBKEY_INVALID
  patch do
    url "https://github.com/openssl/openssl/commit/7107798ae6c5e19f581915928a69073d17cc21ab.diff"
    sha256 "a13d63f0e5b5bcebe27eca7c20286843e105bc794e9b2bfa5f6e162174a0e135"
  end

  # 1.0.2f: add required checks in DH_check_pub_key()
  patch do
    url "https://github.com/openssl/openssl/commit/83ab6e55a1f8de9b3e45d13dcc78eb739dc66dea.diff"
    sha256 "98443034f57e5c4fd1bd89dbf64e9b150184522d10b6a6f7bb7e67cc397615c2"
  end

  keg_only :provided_by_osx,
    "Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries"

  option :universal
  option "without-test", "Skip build-time tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "makedepend" => :build

  # Xcode 7 Clang fix introduced regression which makes older Clang versions
  # incorrectly declare suitable instructions.
  # https://github.com/openssl/openssl/issues/494
  # https://svn.macports.org/repository/macports/trunk/dports/devel/openssl/files/fix-Apple-clang-version-detection.patch
  if MacOS.version <= :mountain_lion
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/312f6228/openssl/fix-Apple-clang-version-detection.patch"
      sha256 "a3e0e13e6c70d85d916bb88cbddc134952794d6292fbab4f2740ac9a07759606"
    end
  end

  def arch_args
    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386   => %w[darwin-i386-cc],
    }
  end

  def configure_args; %W[
    --prefix=#{prefix}
    --openssldir=#{openssldir}
    no-ssl2
    zlib-dynamic
    shared
    enable-cms
  ]
  end

  def install
    # Load zlib from an explicit path instead of relying on dyld's fallback
    # path, which is empty in a SIP context. This patch will be unnecessary
    # when we begin building openssl with no-comp to disable TLS compression.
    # https://langui.sh/2015/11/27/sip-and-dlopen
    inreplace "crypto/comp/c_zlib.c",
              'zlib_dso = DSO_load(NULL, "z", NULL, 0);',
              'zlib_dso = DSO_load(NULL, "/usr/lib/libz.dylib", NULL, DSO_FLAG_NO_NAME_TRANSLATION);'

    if build.universal?
      ENV.permit_arch_flags
      archs = Hardware::CPU.universal_archs
    elsif MacOS.prefer_64_bit?
      archs = [Hardware::CPU.arch_64_bit]
    else
      archs = [Hardware::CPU.arch_32_bit]
    end

    dirs = []

    archs.each do |arch|
      if build.universal?
        dir = "build-#{arch}"
        dirs << dir
        mkdir dir
        mkdir "#{dir}/engines"
        system "make", "clean"
      end

      ENV.deparallelize
      system "perl", "./Configure", *(configure_args + arch_args[arch])
      system "make", "depend"
      system "make"

      if (MacOS.prefer_64_bit? || arch == MacOS.preferred_arch) && build.with?("test")
        system "make", "test"
      end

      if build.universal?
        cp "include/openssl/opensslconf.h", dir
        cp Dir["*.?.?.?.dylib", "*.a", "apps/openssl"], dir
        cp Dir["engines/**/*.dylib"], "#{dir}/engines"
      end
    end

    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"

    if build.universal?
      %w[libcrypto libssl].each do |libname|
        system "lipo", "-create", "#{dirs.first}/#{libname}.1.0.0.dylib",
                                  "#{dirs.last}/#{libname}.1.0.0.dylib",
                       "-output", "#{lib}/#{libname}.1.0.0.dylib"
        system "lipo", "-create", "#{dirs.first}/#{libname}.a",
                                  "#{dirs.last}/#{libname}.a",
                       "-output", "#{lib}/#{libname}.a"
      end

      Dir.glob("#{dirs.first}/engines/*.dylib") do |engine|
        libname = File.basename(engine)
        system "lipo", "-create", "#{dirs.first}/engines/#{libname}",
                                  "#{dirs.last}/engines/#{libname}",
                       "-output", "#{lib}/engines/#{libname}"
      end

      system "lipo", "-create", "#{dirs.first}/openssl",
                                "#{dirs.last}/openssl",
                     "-output", "#{bin}/openssl"

      confs = archs.map do |arch|
        <<-EOS.undent
          #ifdef __#{arch}__
          #{(buildpath/"build-#{arch}/opensslconf.h").read}
          #endif
          EOS
      end
      (include/"openssl/opensslconf.h").atomic_write confs.join("\n")
    end
  end

  def openssldir
    etc/"openssl"
  end

  def post_install
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m
    )

    valid_certs = certs.select do |cert|
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $?.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert (HOMEBREW_PREFIX/"etc/openssl/openssl.cnf").exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
