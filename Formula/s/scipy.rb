class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/53/10/776750d57ade26522478a92a2e14035868624a6a62f4157b0cc5abd4a980/scipy-1.5.2.tar.gz"
  sha256 "066c513d90eb3fd7567a9e150828d39111ebd88d3e924cdfc9f8ce19ab6f90c9"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "be1e59d00561966180e718918c7d6caf1ea01a38020574dbb0d23021d11d19d2" => :catalina
    sha256 "cc394fd2371a6ed3eec03e72829c74b25d2a5e99d4cd42ddc181589c3c14530b" => :mojave
    sha256 "1479546b40f3ab749beb7ab6e07349b9fdd9e1ed1b0a2b64facf4b554a2c01eb" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.8"

  cxxstdlib_check :skip

  # Fix compilation with Xcode 12
  # https://github.com/scipy/scipy/issues/12935
  # https://github.com/scipy/scipy/pull/12243
  patch do
    url "https://github.com/scipy/scipy/commit/b8e47064.diff?full_index=1"
    sha256 "7b2fdb01fc3af54e189c3ec4785c6d69ea63d9bd12aac83c9eaedd393c01591d"
  end

  # Fix compilation with Xcode 12
  # https://github.com/scipy/scipy/issues/12860
  patch do
    url "https://github.com/scipy/scipy/commit/de679deb.diff?full_index=1"
    sha256 "23d957effb33494c73a12a6bca2866c9b6aa9ba94d69744a32231965dd6b949e"
  end

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import scipy"
  end
end
