class Sentencepiece < Formula
  desc "Unsupervised text tokenizer and detokenizer"
  homepage "https://github.com/google/sentencepiece"
  url "https://github.com/google/sentencepiece/archive/v0.1.85.tar.gz"
  sha256 "dd4956287a1b6af3cbdbbd499b7227a859a4e3f41c9882de5e6bdd929e219ae6"

  bottle do
    sha256 "c0e71cae71b5a2c8d0052b38817516a51577c50f85619e4f9327c7b654db5972" => :catalina
    sha256 "c8456af911004feb87645fe9e72894fe5ac238b6824738a49d45dec82e8f319f" => :mojave
    sha256 "10a201a9c6db2cdf979dffb9423565ff69529ce7de182fc69c739f81a34156de" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp (pkgshare/"data/botchan.txt"), testpath
    system "#{bin}/spm_train", "--input=botchan.txt", "--model_prefix=m", "--vocab_size=1000"
  end
end
