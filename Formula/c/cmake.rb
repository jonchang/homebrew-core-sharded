class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.0/cmake-3.19.0.tar.gz"
  sha256 "fdda688155aa7e72b7c63ef6f559fca4b6c07382ea6dca0beb5f45aececaf493"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "278f3741ae2d1c875a87c655150d7722da93310654e58b7473f98d5331b23081" => :big_sur
    sha256 "e057f836dd9e3de9014bc61680c187d08ed24d7631be41da16cd456adce18697" => :catalina
    sha256 "64e495953f8f6277f8e5e9e1ea2ab7ed8adcec4f03ca452c4eaad7bd915f5843" => :mojave
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # Backport patch for 3.19.0: https://gitlab.kitware.com/cmake/cmake/-/issues/21469
  patch do
    url "https://gitlab.kitware.com/cmake/cmake/-/commit/30aa715fac06deba7eaa3e6167cf34eb4d2521d0.patch"
    sha256 "471843b53ea5749eda8b32ef69f9ab20c17e0087992ce3bf8cba93e6e87c54b5"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
