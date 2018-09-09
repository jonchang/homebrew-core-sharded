class Ucloud < Formula
  desc "The official tool to managment your ucloud services"
  homepage "https://www.ucloud.cn"
  url "https://ucloud-sdk.dl.ufileos.com/ucloud-cli-0.1.2.tar.gz"
  sha256 "f41aaa6bf8063b3ccd0c5e41d3dc90f46f9fb45066513da8e306456f1f332071"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/ucloud/ucloud-cli"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"ucloud"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ucloud", "config", "set", "region", "cn-bj2"
    system "#{bin}/ucloud", "config", "set", "project-id", "org-test"
    config_json = (testpath/".ucloud/config.json").read
    assert_match '"region":"cn-bj2"', config_json
    assert_match '"project_id":"org-test"', config_json
    assert_match version.to_s, shell_output("#{bin}/ucloud version")
  end
end
