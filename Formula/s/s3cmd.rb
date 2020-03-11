class S3cmd < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for the Amazon S3 service"
  homepage "https://s3tools.org/s3cmd"
  url "https://files.pythonhosted.org/packages/3a/f5/c70bfb80817c9d81b472e077e390d8c97abe130c9e86b61307a1d275532c/s3cmd-2.0.2.tar.gz"
  sha256 "6d7a3a49a12048a6c8e5fbb5ef42a83101e2fc69f16013d292b7f37ecfc574a0"
  revision 3
  head "https://github.com/s3tools/s3cmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0627257d8f5f897d8e256646ec08ab3a5275b8eb0f477f3227a95d5fed9ba8c" => :catalina
    sha256 "b64f9fa8cb6ba4c2eb5183f6bf40735dbee52d673d198cdf1fdcedf4d29ed1b3" => :mojave
    sha256 "570fd3c229506b4afaf8f9a78e9566537d649ed53f99a3a732bd35eb637f85ac" => :high_sierra
  end

  depends_on "python@3.8"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/84/30/80932401906eaf787f2e9bd86dc458f1d2e75b064b4c187341f29516945c/python-magic-0.4.15.tar.gz"
    sha256 "f3765c0f582d2dfc72c15f3b5a82aecfae9498bd29ca840d72f37d7bd38bfcd5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  def install
    ENV["S3CMD_INSTPATH_MAN"] = man
    virtualenv_install_with_resources
  end

  test do
    system bin/"s3cmd", "--help"
  end
end
