# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://github.com/rg3/youtube-dl/releases/download/2016.12.12/youtube-dl-2016.12.12.tar.gz"
  sha256 "643efa7755ac4aa03a241f106d8923dfd5dbaf8d3c14e56b696048c4f2fab430"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1fb89ccc5c463334d43252043dbe6fd4517962865a567fa5bf5b0d929649321" => :sierra
    sha256 "30a49790f4e7adf36d171f276056a9e46d84c9d577ca0b570aed301ee2e1f9f5" => :el_capitan
    sha256 "30a49790f4e7adf36d171f276056a9e46d84c9d577ca0b570aed301ee2e1f9f5" => :yosemite
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
