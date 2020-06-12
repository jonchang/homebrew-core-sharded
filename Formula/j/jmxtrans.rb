class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-271.tar.gz"
  sha256 "4aee400641eaeee7f33e1253043b1e644f8a9ec18f95ddc911ff8d35e2ca6530"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4bbf264bf2d65ba622358f879cce60433636d7fd91c1f7c0e04d5869e42886d7" => :catalina
    sha256 "8ba9f5d54de8350421d72dfbbaa821e89d8707e5177a7156ce55f87e89befcfd" => :mojave
    sha256 "a443805c63b0b51d4b13dfa2cc92b0d3f04ec2bcca3cffedb27ccd1e8d124fad" => :high_sierra
    sha256 "3b9479ac46dc39a6f0a69bf43c5469abb31f33de6f51159ba6754a52d4127d7c" => :sierra
    sha256 "3a21472f2c7858af301650a533be93ff9d4589e8497a7ada7dfe9165a4b00987" => :el_capitan
  end

  depends_on "maven" => :build
  depends_on :java => "1.8"

  def install
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true",
                             "-Duser.home=#{buildpath}"

    cd "jmxtrans" do
      # Point JAR_FILE into Cellar where we've installed the jar file
      vers = version.to_s.split("-").last
      inreplace "jmxtrans.sh", "$( cd \"$( dirname \"${BASH_SOURCE[0]}\" )/../lib\" "\
                ">/dev/null && pwd )/jmxtrans-all.jar",
                libexec/"target/jmxtrans-#{vers}-all.jar"

      # Exec java to avoid forking the server into a new process
      inreplace "jmxtrans.sh", "${JAVA} -server", "exec ${JAVA} -server"

      chmod 0755, "jmxtrans.sh"
      libexec.install %w[jmxtrans.sh target]
      pkgshare.install %w[bin example.json src tools vagrant]
      doc.install Dir["doc/*"]
    end

    (bin/"jmxtrans").write_env_script libexec/"jmxtrans.sh", Language::Java.java_home_env("1.8")
  end

  test do
    jmx_port = free_port
    fork do
      ENV["JMX_PORT"] = jmx_port.to_s
      exec bin/"jmxtrans", pkgshare/"example.json"
    end
    sleep 2

    system "nc", "-z", "localhost", jmx_port
  end
end
