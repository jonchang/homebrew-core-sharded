class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/1.0.1.tar.gz"
  sha256 "0c43e7414b308bc29ef6f04e84b02aaf3e0ac4837522d34f84359a54c0a4d54b"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ec910ead4b99bdcaa2649a01a207257d56ba6e8d51233b18220637f968eb6d2" => :el_capitan
    sha256 "a77681880f954d6e3337c582d589cb23b5b34e09a3d787737567278fbb33fc45" => :yosemite
    sha256 "87050e61def08fe7c2c4b521c5ddc607348987241a94efeb91cf699e84fe63e0" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "#{testpath}/test"
    system "git", "commit", "--message", "test"
    system "git", "standup", "HEAD"
  end
end
