class Microplane < Formula
  desc "CLI tool to make git changes across many repos"
  homepage "https://github.com/Clever/microplane"
  url "https://github.com/Clever/microplane/archive/v0.0.21.tar.gz"
  sha256 "8deb72bdc72f96420decee7b680fa8f5feb48adc39f31e091e44a57734a4a575"
  license "Apache-2.0"
  head "https://github.com/Clever/microplane.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d68bf03327811a42c6187c44aa036fe95063109580b0cd0a2850bf6dedff2a3d" => :catalina
    sha256 "868395416f7071c4f225930c1c1bd5c0a8544f45891c578c1801b580cb4e606e" => :mojave
    sha256 "078f2d72287107c94382ec3f985f58ccc80fc8620750ac44718938da36e62634" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/Clever/microplane"
    dir.install buildpath.children
    cd "src/github.com/Clever/microplane" do
      system "make", "install_deps"
      system "make", "build"
      bin.install "bin/mp"
    end
  end

  test do
    # mandatory env variable
    ENV["GITHUB_API_TOKEN"] = "test"
    # create repos.txt
    (testpath/"repos.txt").write <<~EOF
      hashicorp/terraform
    EOF
    # create mp/init.json
    shell_output("mp init -f #{testpath}/repos.txt")
    # test command
    output = shell_output("mp plan -b microplaning -m 'microplane fun' -r terraform -- sh echo 'hi' 2>&1")
    assert_match "planning", output
  end
end
