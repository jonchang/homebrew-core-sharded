class Fig < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.3.0.tar.gz"
  sha256 "7fcf5ce1df5c53aedcfc875c2620035c735d75191ace6bc8ad97b9aeb522f153"

  bottle do
    sha256 "42c21d5454a5e4eed111e925744a56845a979e408e2d7bcef4c6cc17baa6d6c7" => :yosemite
    sha256 "0ca8ccee1dbb569031fde091aa786c485f70c5905b25d8897c46033488f30f2e" => :mavericks
    sha256 "6be5dfaadf213b2624c97e331f17f6499d16bc5aabeb136d6a2d084ee4ea4021" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Boot2Docker,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "boot2docker" => :recommended

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.2.3.tar.gz"
    sha256 "5328a7f4a2d812da166b3fb59211fca976c9f48bb9f8b17d9f3fd4ef7c765ac5"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.4.tar.gz"
    sha256 "a51044cc49089a2408fdf6769a63eebe0b16d91f34716ecee681984446ce467d"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.3.tar.gz"
    sha256 "f333ac915e7c5daddc7d4877b096beafe74ea88b4b746f82a4b110f84e348701"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.1.tar.gz"
    sha256 "490b111c824d64b84797a899a4c22618bbc45323ac24a0a0bb4b73a8758e943c"
  end

  resource "websocket-client" do
    url "https://github.com/liris/websocket-client/archive/v0.29.0.tar.gz"
    sha256 "011487a1fd3158ec670f3c25a40bbe7523f6d22fa342ca870fefe0fa2168aeec"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install "contrib/completion/bash/docker-compose"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    ln_s bin/"docker-compose", bin/"fig"
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-compose --version")
  end
end
