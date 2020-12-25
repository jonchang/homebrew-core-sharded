class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/ea/7e/b54db7887238ed3830200072d0414dfbabc64890a0f18ebcbef5b03359da/vit-2.0.0.tar.gz"
  sha256 "5282d8076d9814d9248071aec8784cffbd968601542533ccb28ca61d1d08205e"
  license "MIT"
  revision 2
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "74f88c7e830cabe5c94a7b375186967a0ec911a9cffa51819ddd24034ef51862" => :big_sur
    sha256 "beb362f7a6835aacc58308494f648723e2bfcaba198dba14a27b6ff18596297a" => :arm64_big_sur
    sha256 "443aacf6cdd09d3667d51fdf272315234d074731e11d965a8518a86a9e536e84" => :catalina
    sha256 "97eabbf5cebec0dda1322f73294302159d53c2f9c4ccfce5056edde44081b682" => :mojave
  end

  depends_on "python@3.9"
  depends_on "task"

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/82/c3/534ddba230bd4fbbd3b7a3d35f3341d014cca213f369a9940925e7e5f691/pytz-2019.3.tar.gz"
    sha256 "b02c06db6cf09c12dd25137e563b31700d3b80fcc4ad23abb7a315f2789819be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/ae/23/3de1856314e8aa87330c57b5c6f8c8738c4fca72bc96fa10b54f7524c752/tasklib-1.3.0.tar.gz"
    sha256 "5b478c53d5b531e072d1374bb4763249d137a094d93621e6ebe2f3f10c52d9a7"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/c6/52/5ec375d4efcbe4e31805f3c4b301bdfcff9dcbdb3605d4b79e117a16b38d/tzlocal-2.0.0.tar.gz"
    sha256 "949b9dd5ba4be17190a80c0268167d7e6c92c62b30026cf9764caf3e308e5590"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/45/dd/d57924f77b0914f8a61c81222647888fbb583f89168a376ffeb5613b02a6/urwid-2.1.0.tar.gz"
    sha256 "0896f36060beb6bf3801cb554303fef336a79661401797551ba106d23ab4cd86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
