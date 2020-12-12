require "language/node"

class Appium < Formula
  desc "Automation for Apps"
  homepage "https://appium.io/"
  url "https://registry.npmjs.org/appium/-/appium-1.19.1.tgz"
  sha256 "c24f11fe3dba96a9c9d41300e53251b7e8423b88911abd4a5d1ef42bb77fffa0"
  license "Apache-2.0"
  head "https://github.com/appium/appium.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "4ea1dbc255495f77ccd8b8eef8a8e0244ce0c4d5e302f39f0ca4ed07d4fb087c" => :catalina
    sha256 "ed7587c1b90e17ace1d8882bb393e9af52fe85e35c2fcb944b906878e39ee243" => :mojave
    sha256 "e16208f7f59caa4b0676051413e849556a6f9865b2da3f965eaac44d52f42bfe" => :high_sierra
  end

  depends_on "node"

  def install
    # workaround packaging bug exposed in npm 7+ (bin smylinks are now created
    # before installing dependencies) => manually create symlink for authorize-ios
    inreplace "package.json", "\"appium\": \"./build/lib/main.js\",", "\"appium\": \"./build/lib/main.js\""
    inreplace "package.json", "\"authorize-ios\": \"./node_modules/.bin/authorize-ios\"", ""
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    ln_s libexec/"lib/node_modules/appium/node_modules/.bin/authorize-ios", libexec/"bin/authorize-ios"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appium --show-config 2>&1")
    assert_match version.to_str, output

    port = free_port
    begin
      pid = fork do
        exec bin/"appium --port #{port} &>appium-start.out"
      end
      sleep 3

      assert_match "unknown command", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
