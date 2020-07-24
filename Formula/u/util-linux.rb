class UtilLinux < Formula
  desc "Collection of Linux utilities"
  homepage "https://github.com/karelzak/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.36/util-linux-2.36.tar.xz"
  sha256 "9e4b1c67eb13b9b67feb32ae1dc0d50e08ce9e5d82e1cccd0ee771ad2fa9e0b1"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "415a5e3671b1f64bbd23a056ec338c539d54d7f6010f28498bede2af6c039df4" => :catalina
    sha256 "32bd744a8adbfbaa6d7c3bd2eef1b8ee752e74f2e53b4f3d7dd355ce59a7719c" => :mojave
    sha256 "8bcf4fbc8f58f8e0d7ecb77bfec6686ee2150b3c2509fa5006417f395803f467" => :high_sierra
  end

  keg_only "macOS provides the uuid.h header"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # These binaries are already available in macOS
  def system_bins
    %w[
      cal col colcrt colrm
      getopt
      hexdump
      logger look
      mesg more
      nologin
      renice rev
      ul
      whereis
    ]
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-ipcs",  # does not build on macOS
                          "--disable-ipcrm", # does not build on macOS
                          "--disable-wall",  # already comes with macOS
                          "--enable-libuuid" # conflicts with ossp-uuid

    system "make", "install"

    # Remove binaries already shipped by macOS
    system_bins.each do |prog|
      rm_f bin/prog
      rm_f sbin/prog
      rm_f man1/"#{prog}.1"
      rm_f man8/"#{prog}.8"
      rm_f share/"bash-completion/completions/#{prog}"
    end

    # install completions only for installed programs
    Pathname.glob("bash-completion/*") do |prog|
      bash_completion.install prog if (bin/prog.basename).exist? || (sbin/prog.basename).exist?
    end
  end

  def caveats
    linux_only_bins = %w[
      addpart agetty
      blkdiscard blkzone blockdev
      chcpu chmem choom chrt ctrlaltdel
      delpart dmesg
      eject
      fallocate fdformat fincore findmnt fsck fsfreeze fstrim
      hwclock
      ionice ipcrm ipcs
      kill
      last ldattach losetup lsblk lscpu lsipc lslocks lslogins lsmem lsns
      mount mountpoint
      nsenter
      partx pivot_root prlimit
      raw readprofile resizepart rfkill rtcwake
      script scriptlive setarch setterm sulogin swapoff swapon switch_root
      taskset
      umount unshare utmpdump uuidd
      wall wdctl
      zramctl
    ]
    <<~EOS
      The following tools are not supported under macOS, and are therefore not included:
      #{Formatter.wrap(Formatter.columns(linux_only_bins), 80)}
      The following tools are already shipped by macOS, and are therefore not included:
      #{Formatter.wrap(Formatter.columns(system_bins), 80)}
    EOS
  end

  test do
    stat  = File.stat "/usr"
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name

    flags = ["x", "w", "r"] * 3
    perms = flags.each_with_index.reduce("") do |sum, (flag, index)|
      sum.insert 0, ((stat.mode & (2 ** index)).zero? ? "-" : flag)
    end

    out = shell_output("#{bin}/namei -lx /usr").split("\n").last.split(" ")
    assert_equal ["d#{perms}", owner, group, "usr"], out
  end
end
