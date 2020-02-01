require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.5.tar.gz"
  sha256 "385e5b5c6c5f962073764ceb2350326ce6effef5304135b20bea04427dccbe1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "8188ae83745bef4a9d28d5d08faff1bf9c27522ba0cd2f55f77e8dbbcbebd5a2" => :catalina
    sha256 "60a4ad1f6c0fd4514ab34bcbc0ed2187266958d604b12c6a4126494cbe633f95" => :mojave
    sha256 "44ca2612d78903494068ee04720570f2575eaa163495b19913a8bfd22b078b40" => :high_sierra
  end

  depends_on "haskell-stack" => :build

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
