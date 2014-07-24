require "formula"

class Riak < Formula
  homepage "http://basho.com/riak/"
  url "http://s3.amazonaws.com/downloads.basho.com/riak/1.4/1.4.9/osx/10.8/riak-1.4.9-OSX-x86_64.tar.gz"
  version "1.4.9"
  sha256 "50dd4a423539ed309fc983820e9cfde250be2927efd85c3e8c0dff9281d63ab5"

  devel do
    url "http://s3.amazonaws.com/downloads.basho.com/riak/2.0/2.0.0rc1/osx/10.8/riak-2.0.0rc1-OSX-x86_64.tar.gz"
    sha256 "785c93fb98ce2ab21ffc7644756bed95c9ba1eae46283536609fa93b0287909d"
    version "2.0.0-rc1"
  end

  depends_on :macos => :mountain_lion
  depends_on :arch => :x86_64

  def install
    logdir = var + "log/riak"
    datadir = var + "lib/riak"
    libexec.install Dir["*"]
    logdir.mkpath
    datadir.mkpath
    (datadir + "ring").mkpath
    inreplace "#{libexec}/lib/env.sh" do |s|
      s.change_make_var! "RUNNER_BASE_DIR", libexec
      s.change_make_var! "RUNNER_LOG_DIR", logdir
    end
    if build.devel?
      inreplace "#{libexec}/etc/riak.conf" do |c|
        c.gsub! /(platform_data_dir *=).*$/, "\\1 #{datadir}"
        c.gsub! /(platform_log_dir *=).*$/, "\\1 #{logdir}"
      end
    else
      inreplace "#{libexec}/etc/app.config" do |c|
        c.gsub! './data', datadir
        c.gsub! './log', logdir
      end
    end
    bin.write_exec_script libexec/"bin/riak"
    bin.write_exec_script libexec/"bin/riak-admin"
    bin.write_exec_script libexec/"bin/riak-debug"
    bin.write_exec_script libexec/"bin/search-cmd"
  end
end
