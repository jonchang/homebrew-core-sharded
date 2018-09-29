class Grv < Formula
  desc "Terminal interface for viewing git repositories"
  homepage "https://github.com/rgburke/grv"
  url "https://github.com/rgburke/grv/releases/download/v0.3.0/grv-0.3.0-src.tar.gz"
  sha256 "ee1b51bfcc1a5c1b4c71b3b84cae6370eced5dfcb4c677c53c75aab370edab63"
  head "https://github.com/rgburke/grv.git"

  bottle do
    cellar :any
    sha256 "49d394c493aceb17b73c6995255e22f4ae334631862e0bbf5ed6b0182205ab44" => :high_sierra
    sha256 "685cf936f826b9f12a013f90a2e2eda256a200476283cf09eb4539abb70702cb" => :sierra
    sha256 "c660e8bb6f3f3d7ac84c03eac926c84e4cb98e7cb4ab338ccc61a17f9eeeef70" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "readline"

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/rgburke/grv"
    path.install buildpath.children

    cd path do
      system "make", "build-only"
      bin.install "grv"
      prefix.install_metafiles
    end
  end

  test do
    ENV["TERM"] = "xterm"

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "test"
    pipe_output("#{bin}/grv -logLevel DEBUG", "'<grv-exit>'", 0)

    assert_predicate testpath/"grv.log", :exist?
    assert_match "Loaded HEAD", File.read(testpath/"grv.log")
  end
end
