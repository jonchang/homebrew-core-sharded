class PassOtp < Formula
  desc "The Pass extension for managing one-time-password (OTP) tokens"
  homepage "https://github.com/tadfisher/pass-otp#readme"
  url "https://github.com/tadfisher/pass-otp/releases/download/v1.1.1/pass-otp-1.1.1.tar.gz"
  sha256 "edb3142ab81d70af4e6d1c7f13abebd7c349be474a3f9293d9648ee91b75b458"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc63fb7142bc11d6fcb3fd86691c520d322955ca18fa639610b4f8c741ec47a1" => :mojave
    sha256 "fee46f4b49b58c1a689be63e16eaa813471bcd435b21c46519ac0a8af9f555c7" => :high_sierra
    sha256 "fee46f4b49b58c1a689be63e16eaa813471bcd435b21c46519ac0a8af9f555c7" => :sierra
  end

  depends_on "oath-toolkit"
  depends_on "pass"

  def install
    system "make", "PREFIX=#{prefix}", "BASHCOMPDIR=#{bash_completion}", "install"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system "pass", "init", "Testing"
      require "open3"
      Open3.popen3("pass", "otp", "insert", "hotp-secret") do |stdin, _, _|
        stdin.write "otpauth://hotp/hotp-secret?secret=AAAAAAAAAAAAAAAA&counter=1&issuer=hotp-secret"
        stdin.close
      end
      assert_equal "073348", `pass otp show hotp-secret`.strip
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
