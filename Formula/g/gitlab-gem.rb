class GitlabGem < Formula
  desc "Ruby client and CLI for GitLab API"
  homepage "https://github.com/NARKOZ/gitlab"
  url "https://github.com/NARKOZ/gitlab/archive/v4.15.0.tar.gz"
  sha256 "13157f6f99f17b387b1af7adb7a2afcb4037c7e148fb903d459e2d4ad433ce82"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a41f838c6b4c01bd88573bd2a0dc3d7ebfbac30a184a205c9f1ebed0d97b47a" => :catalina
    sha256 "1f62b1370f402910440d06723da59ada32cfb064ffa7dcff253a6c3740299f80" => :mojave
    sha256 "004e1b420646231af5ca551812a0c52499fcfe5b794761c6416712140a451679" => :high_sierra
  end

  uses_from_macos "ruby", :since => :catalina

  resource "httparty" do
    url "https://rubygems.org/gems/httparty-0.18.0.gem"
    sha256 "c6f77f117ca6e7aeaf5405d0992edd43f19f4fa5eea79e9a4fdfdb287cfeee6f"
  end

  resource "mime-types" do
    url "https://rubygems.org/gems/mime-types-3.3.1.gem"
    sha256 "708f737e28ceef48b9a1bc041aa9eec46fa36eb36acb95e6b64a9889131541fe"
  end

  resource "mime-types-data" do
    url "https://rubygems.org/gems/mime-types-data-3.2020.0512.gem"
    sha256 "a31c1705fec7fc775749742c52964a0e012968b43939e141a74f43ffecd6e5fc"
  end

  resource "multi_xml" do
    url "https://rubygems.org/gems/multi_xml-0.6.0.gem"
    sha256 "d24393cf958adb226db884b976b007914a89c53ad88718e25679d7008823ad52"
  end

  resource "terminal-table" do
    url "https://rubygems.org/gems/terminal-table-1.8.0.gem"
    sha256 "13371f069af18e9baa4e44d404a4ada9301899ce0530c237ac1a96c19f652294"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/gems/unicode-display_width-1.7.0.gem"
    sha256 "cad681071867a4cf52613412e379e39e85ac72b1d236677a2001187d448b231a"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "gitlab.gemspec"
    system "gem", "install", "--ignore-dependencies", "gitlab-#{version}.gem"
    (bin/"gitlab").write_env_script libexec/"bin/gitlab", :GEM_HOME => ENV["GEM_HOME"]
  end

  test do
    ENV["GITLAB_API_ENDPOINT"] = "https://example.com/"
    ENV["GITLAB_API_PRIVATE_TOKEN"] = "token"
    output = shell_output("#{bin}/gitlab user 2>&1", 1)
    assert_match "Server responded with code 404", output
  end
end
