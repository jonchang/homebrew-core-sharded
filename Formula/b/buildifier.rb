class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "2.0.0",
      :revision => "2797858400171ffaa3074c22925b05ed54b634f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "62f0325685b520d81ea00e5c59de99b1e9647a121808d60c0d6414fc6847db03" => :catalina
    sha256 "62f0325685b520d81ea00e5c59de99b1e9647a121808d60c0d6414fc6847db03" => :mojave
    sha256 "62f0325685b520d81ea00e5c59de99b1e9647a121808d60c0d6414fc6847db03" => :high_sierra
  end

  depends_on "bazel" => :build

  def install
    system "bazel", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
