class LaunchSocketServer < Formula
  desc "Bind to privileged ports without running a server as root"
  homepage "https://github.com/sstephenson/launch_socket_server"
  url "https://github.com/sstephenson/launch_socket_server/archive/v1.0.0.tar.gz"
  sha256 "77b7eebf54a1f0e0ce250b3cf3fa19eb6bee6cb6d70989a9b6cd5b6a95695608"

  revision 1

  head "https://github.com/sstephenson/launch_socket_server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5b02931059c10da42c4b6728ac3c2eddd2a66ba83dfa440b2a9ad516eedda19" => :el_capitan
    sha256 "7b916580395c0b3bab57e8e657f87876764a94d44965ff3466da2a04a9db57ef" => :yosemite
    sha256 "0d66071633171732bb931feaf6b3cbec31d29141e2172d6118e3bcde4a39e4f9" => :mavericks
  end

  depends_on "go" => :build
  depends_on :macos => :yosemite

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :startup => true

  def plist
    <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/launch_socket_server</string>
            <string>-</string>
          </array>
          <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
          <dict>
            <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
            <string>127.0.0.1:8080</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/launch_socket_server.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    launch_port = 9272
    echo_port = 6752

    (testpath/"launch_socket_server.plist").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>homebrew.mxcl.launch_socket_server_test</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/launch_socket_server</string>
            <string>/usr/bin/ruby</string>
            <string>#{testpath}/echo_server.rb</string>
          </array>
          <key>Sockets</key>
          <dict>
            <key>Socket</key>
            <dict>
              <key>SockNodeName</key>
              <string>127.0.0.1</string>
              <key>SockServiceName</key>
              <string>#{launch_port}</string>
            </dict>
          </dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>LAUNCH_PROGRAM_TCP_ADDRESS</key>
            <string>127.0.0.1:#{echo_port}</string>
          </dict>
          <key>StandardErrorPath</key>
          <string>#{testpath}/launch_socket_server.log</string>
          <key>StandardOutPath</key>
          <string>#{testpath}/launch_socket_server.log</string>
        </dict>
      </plist>
    EOS

    (testpath/"echo_server.rb").write <<-EOS.undent
      require "socket"

      server = TCPServer.new("127.0.0.1", "#{echo_port}")
      socket = server.accept
      socket.puts socket.readline
    EOS

    system "launchctl", "load", testpath/"launch_socket_server.plist"

    sleep 1

    begin
      socket = TCPSocket.new "127.0.0.1", launch_port
      socket.puts "hello, world"
      output = socket.gets.strip
      socket.close
    ensure
      system "launchctl", "unload", testpath/"launch_socket_server.plist"
    end

    assert_equal "hello, world", output
  end
end
