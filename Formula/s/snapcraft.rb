class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft/archive/3.9.8.tar.gz"
  sha256 "98e52347e0080cb4b08290b1c0814b2f20d2a9da1c337fe21bf24345bb04bc68"

  bottle do
    cellar :any
    sha256 "4dc957bcbcf39aadbfb64d52e255a4ac96e0efde7fa8315a4d3b109423f08f5f" => :catalina
    sha256 "97893cf300303f787db1203091f28ea12d8bdc56561a9ea5cadac0ed3d8d7e9e" => :mojave
    sha256 "3f0ffa2d631a534eff10e9d62c2c795f5d70c32b69e12aa59780a75aabdee624" => :high_sierra
  end

  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "python"
  depends_on "squashfs"
  depends_on "xdelta"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2d/bf/960e5a422db3ac1a5e612cb35ca436c3fc985ed4b7ed13a1b4879006f450/cffi-1.13.2.tar.gz"
    sha256 "599a1e8ff057ac530c9ad1778293c665cb81a791421f46922d80a86473c13346"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/16/4f/48975536bd488d3a272549eb795ac4a13a5f7fcdc8995def77fbef3532ee/configparser-4.0.2.tar.gz"
    sha256 "c7d282687a5308319bf3d2e7706e575c635b0a470342641c93bea0ea3b5331df"
  end

  resource "cookies" do
    url "https://files.pythonhosted.org/packages/f3/95/b66a0ca09c5ec9509d8729e0510e4b078d2451c5e33f47bd6fc33c01517c/cookies-2.2.1.tar.gz"
    sha256 "d6b698788cae4cfa4e62ef8643a9ca332b79bd96cb314294b864ae8d7eb3ee8e"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/54/3e/ec53cf9e084a158a51bc669c40facfe5c5c93d194ca8fdaf4c933ea05d77/httplib2-0.16.0.tar.gz"
    sha256 "b6a5a3faa31b56d6eaa61b22e328bfa73a877fe4308b02aa98d6d424ff865564"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "importlib_metadata" do
    url "https://files.pythonhosted.org/packages/8c/0e/10e247f40c89ba72b7f2a2104ccf1b65de18f79562ffe11bfb837b711acf/importlib_metadata-1.4.0.tar.gz"
    sha256 "f17c015735e1a88296994c0697ecea7e11db24290941983b08c9feb30921e6d8"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/92/a6/67dc3d485a21c458ed09cd40b15948334f9eb6a86498a85becb223d3a7d8/launchpadlib-1.10.9.tar.gz"
    sha256 "baf5534911bbaf196999daa384748721c0ba75af5f61f60d9205537963fffdfa"
  end

  resource "lazr.restfulclient" do
    url "https://files.pythonhosted.org/packages/0f/32/aa9a79f4402977950228ec36bfaf4b25cf3cb3bc3b6877f5cbcb43761bda/lazr.restfulclient-0.14.2.tar.gz"
    sha256 "1ee3acf3bb38861546251f2f158a5e5df403d93b4b040b08c3f297e24b3a035a"
  end

  resource "lazr.uri" do
    url "https://files.pythonhosted.org/packages/ea/bf/71ad2f5eaf7885d36e3cbd0a87cf3812ad043cf99c9fa6cc6ab4c94ee862/lazr.uri-1.0.3.tar.gz"
    sha256 "5c620b5993c8c6a73084176bfc51de64972b8373620476ed841931a49752dc8b"
  end

  resource "libnacl" do
    url "https://files.pythonhosted.org/packages/08/9b/16725e8cbb278569db379ea6e4eb24b2e8c574be1ec7617ac2dff8f91b2b/libnacl-1.7.1.tar.gz"
    sha256 "33f31c4686541aee24876706b46a846f93c60e62d6b4211bc16bd08ba71d8fb8"
  end

  resource "more_itertools" do
    url "https://files.pythonhosted.org/packages/df/8c/c278395367a46c00d28036143fdc6583db8f98622b83875403f16473509b/more-itertools-8.1.0.tar.gz"
    sha256 "c468adec578380b6281a114cb8a5db34eb1116277da92d7c46f904f0b52d3288"
  end

  resource "mypy_extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/98/8a/defa5215d2dcf98cc80f4783e951a8356e38f352f7a169ae11670dcb1f25/pbr-5.4.4.tar.gz"
    sha256 "139d2625547dbfa5fb0b81daebb39601c478c21956dc57e2e07b74450a8c506b"
  end

  resource "petname" do
    url "https://files.pythonhosted.org/packages/8e/a5/348c90b3fb09d7bd76f7dacf1b92e251d75bfbe715006cb9b84eb23be1b1/petname-2.6.tar.gz"
    sha256 "981c31ef772356a373640d1bb7c67c102e0159eda14578c67a1c99d5b34c9e4c"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/49/9a/eba58646721ffbff40dc41571b13c9528fdc4e26a82252318c997cdbe26a/pylxd-2.2.10.tar.gz"
    sha256 "9b1415fcc54a575fcfd9729eec8a42af99d3f26e1d49a9ce22762b6e14deff2a"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/9e/0f/82583ae6638a23e416cb3f15e3e3c07af51725fe51a4eaf91ede265f4af9/pyelftools-0.26.tar.gz"
    sha256 "86ac6cee19f6c945e8dedf78c6ee74f1112bd14da5a658d8c9d4103aed5756a2"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/90/aa/cdcf7ef88cc0f831b6f14c8c57318824c9de9913fe8de38e46a98c069a35/pyrsistent-0.15.7.tar.gz"
    sha256 "cdc7b5e3ed77bed61270a47d35434a30617b9becdf2478af76ad2c6ade307280"
  end

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/c7/36/1a991e67a9de813e1dbec1bbc41f5531b5370cf4184e78fb597814860a50/python-debian-0.1.36.tar.gz"
    sha256 "c953bb0c54e96887badd2324cc66e1887bf2734f301882cd4fe847a844b518a6"
  end

  resource "pymacaroons-pynacl" do
    url "https://github.com/matrix-org/pymacaroons/archive/v0.9.3.tar.gz"
    sha256 "871399c4dc1dfab7a435df2d5f2954cbba51d275ca2e93a96abb8b35d348fe5a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/3d/d9/ea9816aea31beeadccd03f1f8b625ecf8f645bd66744484d162d84803ce5/PyYAML-5.3.tar.gz"
    sha256 "e9f45bd5b92c7974e59bcd2dcc8631a6b6cc380a904725fce7bc08872e691615"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz"
    sha256 "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/4d/ce/78b651fe0adbd4227578fa432d1bde03b4f4945a70c81e252a2b6a2d895f/requests-unixsocket-0.2.0.tar.gz"
    sha256 "9e5c1a20afc3cf786197ae59c79bcdb0e7565f218f27df5f891307ee8817c1ea"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/60/1e/9fccce8f669a60f58072535ef2e7bb6ceb68cc894b2eb9374be3c7a29a7e/responses-0.10.9.tar.gz"
    sha256 "8ce8cb4e7e1ad89336f8865af152e0563d2e7f0e0b86d2cf75f015f819409243"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/98/87/a7b98aa9256c8843f92878966dc3d8d914c14aad97e2c5ce4798d5743e07/simplejson-3.17.0.tar.gz"
    sha256 "2b4b2b738b3b99819a17feaf118265d0753d5536049ea570b3c43b51c4701e81"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/c4/41/523f6a05e6dc3329a5660f6a81254c6cd87e5cfb5b7482bae3391d86ec3a/tabulate-0.8.6.tar.gz"
    sha256 "5470cc6687a091c7042cee89b2946d9235fe9f6d49c193a4ae2ac7bf386737c8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/e6/21/8194d85e898b2d8c3120a8c0dfb86125c194a725cc2189363fa6f96708c2/wadllib-1.3.3.tar.gz"
    sha256 "1234cfe81e2cf223e56816f86df3aa18801d1770261865d93337b8b603be366e"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/ee/f7/6c3ca4764a8025da9422825c2bc367fdc8dd115ebb52e4ef057f234938c4/zipp-2.0.0.tar.gz"
    sha256 "7ae5ccaca427bafa9760ac3cd8f8c244bfc259794b5b6bb9db4dda2241575d09"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"]="en_US.UTF-8"
    system "#{bin}/snapcraft", "--version"
    system "#{bin}/snapcraft", "--help"
    system "#{bin}/snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
