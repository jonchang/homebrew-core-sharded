class GimmeAwsCreds < Formula
  include Language::Python::Virtualenv

  desc "CLI to retrieve AWS credentials from Okta"
  homepage "https://github.com/Nike-Inc/gimme-aws-creds"
  url "https://files.pythonhosted.org/packages/21/d2/f80fe263ce22cb5a3df87a6e8e06f2166318e368bce9a21343d8c490fc68/gimme%20aws%20creds-2.1.3.tar.gz"
  sha256 "3af7e0f780d2a8ac195772cc4f9a7d6a163e8ef1e841507cfb6676ef7e0941a2"

  bottle do
    cellar :any
    sha256 "0bdb742327fac0108150ed99a8cec5705f52c83d233dc284ac2c2588a40cdd51" => :catalina
    sha256 "f97c68d3bb41a8a4bf60222989d67467b3149503f2fa5d3c5300e91de58e4846" => :mojave
    sha256 "07f601983b1f852fe85d80726ba22f7844ebe4a96fcf61c37fcd35b6a64f8744" => :high_sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "gimme-aws-creds"
    venv.pip_install_and_link buildpath
  end

  test do
    # Workaround gimme-aws-creds bug which runs action-configure twice when config file is missing.
    config_file = Pathname(".okta_aws_login_config")
    touch(config_file)

    output = pipe_output("#{bin}/gimme-aws-creds --action-configure 2>&1", "TESTPROFILE\nhttps://something.oktapreview.com\n\n\n\n\n\n\n\n\n\n\n")
    assert_match "Okta Configuration Profile Name", output
    assert_match "[TESTPROFILE]", config_file.read

    assert_match version.to_s, shell_output("#{bin}/gimme-aws-creds --version")
  end
end
