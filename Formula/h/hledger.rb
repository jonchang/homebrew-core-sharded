class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.18/hledger-1.18.tar.gz"
  sha256 "866fbb01ff652ec97ff7d12b35e1ee77b5af30e251da042edfc923aaffbae267"

  bottle do
    cellar :any_skip_relocation
    sha256 "f14eb6659b2d23f3134b7596d732c4f80fae76fceaceeda30689b8c9df4b626e" => :catalina
    sha256 "1cdbc6211c26cc20c7ac4cd18aaaa635c1f27d49feed6fbaa5442073c03218d4" => :mojave
    sha256 "3111c83cbd8bb5f0aeb6b719c2ccc9d55b2199f4bfae8361abc3dc7c482f29eb" => :high_sierra
  end

  depends_on "ghc@8.8" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.18/hledger-lib-1.18.tar.gz"
    sha256 "07c7a7e66dcce3c004e906ae79bf302a19991d5806abf1be003a0080469a3f08"
  end
  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.18/hledger-ui-1.18.tar.gz"
    sha256 "917d861e2a1484444357eff1fa9c7da2afdceaa135e2f2a9ef3166d2f98c1983"
  end
  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.18/hledger-web-1.18.tar.gz"
    sha256 "89c7d483c8aa75cbdafb0390ef59d3eccbd0d456b91762fa194b4eda6758ec1d"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      system "stack", "init", "--resolver=lts-15.16"
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--local-bin-path=#{bin}"

      man1.install "hledger-1.18/hledger.1"
      man1.install "hledger-ui/hledger-ui.1"
      man1.install "hledger-web/hledger-web.1"
      man5.install "hledger-lib/hledger_csv.5"
      man5.install "hledger-lib/hledger_journal.5"
      man5.install "hledger-lib/hledger_timeclock.5"
      man5.install "hledger-lib/hledger_timedot.5"

      info.install "hledger-1.18/hledger.info"
      info.install "hledger-lib/hledger_csv.info"
      info.install "hledger-lib/hledger_journal.info"
      info.install "hledger-lib/hledger_timeclock.info"
      info.install "hledger-lib/hledger_timedot.info"
      info.install "hledger-ui/hledger-ui.info"
      info.install "hledger-web/hledger-web.info"
    end
  end

  test do
    system "#{bin}/hledger", "test"

    File.open(".hledger.journal", "w") do |f|
      f.write <<~EOS
        2020/1/1
          boat  123
          cash
      EOS
    end

    system "#{bin}/hledger-ui", "--version"

    pid = fork do
      exec "#{bin}/hledger-web", "--serve"
    end
    sleep 1
    begin
      assert_match /boat +123/, shell_output("curl -s http://127.0.0.1:5000/journal")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
