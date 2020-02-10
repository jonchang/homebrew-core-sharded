class PythonMarkdown < Formula
  desc "Python implementation of Markdown"
  homepage "https://pypi.python.org/pypi/Markdown"
  url "https://files.pythonhosted.org/packages/3a/0b/6deec230d8c30f1ae569e4cfca5fd202d912dbf61f338d4d86b284a40812/Markdown-3.2.tar.gz"
  sha256 "5ad7180c3ec16422a764568ad6409ec82460c40d1631591fa53d597033cc98bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf5cb7dc954d7c90fb3243ac72807a77927cc9c1e73f8bfd7d29b33482a058ea" => :catalina
    sha256 "cf5cb7dc954d7c90fb3243ac72807a77927cc9c1e73f8bfd7d29b33482a058ea" => :mojave
    sha256 "cf5cb7dc954d7c90fb3243ac72807a77927cc9c1e73f8bfd7d29b33482a058ea" => :high_sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
