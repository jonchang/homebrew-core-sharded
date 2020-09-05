class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.3.0.tar.gz"
  sha256 "c8f7daa795af71622e4a78a9458d9e9fd5f1857b5ba87489ec46d22f9a9ca65c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "11902a795449df78e2ce8174379731bdb4de50cc33db13572f4fb2b69d26bc60" => :catalina
    sha256 "824126b2be00c26cab160969986e4087e009770a21f137c30a5a21fec6abfab5" => :mojave
    sha256 "79ba6c6fc6bca016d55960d7746a8b6fd29477eeec4b37d88ae2630d2989f2f2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
