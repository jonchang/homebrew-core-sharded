class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.2.tar.gz"
  sha256 "aff0878ab99758535e18d487c46cc8e376d2eb3a098b5288a39826be86eb5e6c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2e9009355ccc06372f8ac21000c38de63d468d6f15a99a5c3a948ecf7506fe6" => :catalina
    sha256 "b5e2632c0620a4e06a92b641faf4db96773db00f17b12995c44cbd455fe7d277" => :mojave
    sha256 "a9613b97997b4137fe7b8fe56717691711573e320af98a10a4cab03694874f8c" => :high_sierra
  end

  depends_on "python@3.8"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/34/6e/37cbfba703b06fca29c38079bef76cc01e8496197701fff8f0dded3b5b38/aspy.refactor_imports-2.1.1.tar.gz"
    sha256 "eec8d1a73bedf64ffb8b589ad919a030c1fb14acf7d1ce0ab192f6eedae895c5"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
