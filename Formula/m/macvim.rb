# Reference: https://github.com/macvim-dev/macvim/wiki/building
class Macvim < Formula
  desc "GUI for vim, made for macOS"
  homepage "https://github.com/macvim-dev/macvim"
  url "https://github.com/macvim-dev/macvim/archive/snapshot-169.tar.gz"
  version "8.2-169"
  sha256 "3b5bd8631ada8566d7d575696fbe2e0df760f3cdd31c09b47980e3d62e523cc7"
  license "Vim"
  head "https://github.com/macvim-dev/macvim.git"

  bottle do
    sha256 "1b1d92000e321cf0a172c26965404c738be5ac68c51203ee34164152528bd67a" => :big_sur
    sha256 "f2e611635742434ebfaffa952918ac44bbb7c2da40782304b49ee7d847ce62a9" => :catalina
    sha256 "c2c4ffb3a206a59ad3ba17dc70e3a46b5cd25d79cb297732cf8a653018ce2059" => :mojave
  end

  depends_on xcode: :build
  depends_on "cscope"
  depends_on "gettext"
  depends_on "lua"
  depends_on "python@3.9"
  depends_on "ruby"

  conflicts_with "vim",
    because: "vim and macvim both install vi* binaries"

  def install
    # Avoid issues finding Ruby headers
    ENV.delete("SDKROOT")

    # MacVim doesn't have or require any Python package, so unset PYTHONPATH
    ENV.delete("PYTHONPATH")

    # make sure that CC is set to "clang"
    ENV.clang

    system "./configure", "--with-features=huge",
                          "--enable-multibyte",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-tclinterp",
                          "--enable-terminal",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--with-local-dir=#{HOMEBREW_PREFIX}",
                          "--enable-cscope",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}",
                          "--enable-luainterp",
                          "--enable-python3interp",
                          "--disable-sparkle",
                          "--with-macarchs=#{Hardware::CPU.arch}"
    system "make"

    prefix.install "src/MacVim/build/Release/MacVim.app"
    bin.install_symlink prefix/"MacVim.app/Contents/bin/mvim"

    # Create MacVim vimdiff, view, ex equivalents
    executables = %w[mvimdiff mview mvimex gvim gvimdiff gview gvimex]
    executables += %w[vi vim vimdiff view vimex]
    executables.each { |e| bin.install_symlink "mvim" => e }
  end

  test do
    output = shell_output("#{bin}/mvim --version")
    assert_match "+ruby", output
    assert_match "+gettext", output

    # Simple test to check if MacVim was linked to Homebrew's Python 3
    py3_exec_prefix = shell_output(Formula["python@3.9"].opt_bin/"python3-config --exec-prefix")
    assert_match py3_exec_prefix.chomp, output
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"mvim", "-v", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", (testpath/"test.txt").read.chomp
  end
end
