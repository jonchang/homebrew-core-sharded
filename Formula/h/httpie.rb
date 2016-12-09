class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.org/"
  url "https://pypi.python.org/packages/85/95/7ccea3ae7fd1185e21629f6d14fa9c896d6250bb15fb492efa91edc741a2/httpie-0.9.8.tar.gz"
  sha256 "515870b15231530f56fe2164190581748e8799b66ef0fe36ec9da3396f0df6e1"
  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5da06ad61be5af62602b3e66baffaa2fa7c1be286c1315abbf8c1b4d43bc95f" => :sierra
    sha256 "c24867af6ad2263b171e2035923e695ae002c19a45bf05d3568a571c158d4196" => :el_capitan
    sha256 "9f5462576937e26353a4d4ab9a71a97afaa90d7deeede2e961660fa12dddc5c8" => :yosemite
    sha256 "3bcdaf0f9500ffe553706285795d0ad1439073c252c915ff92ccd77095fb5c0e" => :mavericks
  end

  depends_on :python3

  resource "pygments" do
    url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/d9/03/155b3e67fe35fe5b6f4227a8d9e96a14fda828b18199800d161bcefc1359/requests-2.12.3.tar.gz"
    sha256 "de5d266953875e9647e37ef7bfe6ef1a46ff8ddfe61b5b3652edf7ea717ee2b2"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    %w[pygments requests].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end
