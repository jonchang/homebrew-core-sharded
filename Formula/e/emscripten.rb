class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://kripken.github.io/emscripten-site/"

  stable do
    url "https://github.com/emscripten-core/emscripten/archive/1.38.30.tar.gz"
    sha256 "909014ff4d5906d7aad610f6b52cb5a9f3217231c99628b625baa0fbce17214f"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp/archive/1.38.30.tar.gz"
      sha256 "4280a7ebeee34a705d4c95468eed96a4b3c18f30471dacb2466f1ead60cae5bd"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang/archive/1.38.30.tar.gz"
      sha256 "109ac7a57738614cd47c1acde9e4dc8bdcdbc33ba8b27262d1afcaa189023f65"
    end
  end

  bottle do
    cellar :any
    sha256 "ddd8d926d8be78a68d77eae8535340c65c9fef3c4ab5c676e1c995f1c3095cc1" => :mojave
    sha256 "5b52c5a4aa864dafaf95fa89e09fcd3dd080178dbd11e8e043f34efd547a7b0a" => :high_sierra
    sha256 "0eb2b674be12808b8219cb16b288e838f7a9c29c2572ae062e56d997e36a0bca" => :sierra
  end

  head do
    url "https://github.com/emscripten-core/emscripten.git", :branch => "incoming"

    resource "fastcomp" do
      url "https://github.com/emscripten-core/emscripten-fastcomp.git", :branch => "incoming"
    end

    resource "fastcomp-clang" do
      url "https://github.com/emscripten-core/emscripten-fastcomp-clang.git", :branch => "incoming"
    end
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@2"
  depends_on "yuicompressor"

  def install
    ENV.cxx11
    # rewrite hardcoded paths from system python to homebrew python
    python2_shebangs = `grep --recursive --files-with-matches ^#!/usr/bin/python #{buildpath}`
    python2_shebang_files = python2_shebangs.lines.sort.uniq
    python2_shebang_files.map! { |f| Pathname(f.chomp) }
    python2_shebang_files.reject! &:symlink?
    inreplace python2_shebang_files, %r{^#!/usr/bin/python2?$}, "#!#{Formula["python@2"].opt_bin}/python2"

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    (buildpath/"fastcomp").install resource("fastcomp")
    (buildpath/"fastcomp/tools/clang").install resource("fastcomp-clang")

    cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
    cmake_args = [
      "-DCMAKE_BUILD_TYPE=Release",
      "-DCMAKE_INSTALL_PREFIX=#{libexec}/llvm",
      "-DLLVM_TARGETS_TO_BUILD='X86;JSBackend'",
      "-DLLVM_INCLUDE_EXAMPLES=OFF",
      "-DLLVM_INCLUDE_TESTS=OFF",
      "-DCLANG_INCLUDE_TESTS=OFF",
      "-DOCAMLFIND=/usr/bin/false",
      "-DGO_EXECUTABLE=/usr/bin/false",
    ]

    mkdir "fastcomp/build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      bin.install_symlink libexec/emscript
    end
  end

  def caveats; <<~EOS
    Manually set LLVM_ROOT to
      #{opt_libexec}/llvm/bin
    and comment out BINARYEN_ROOT
    in ~/.emscripten after running `emcc` for the first time.
  EOS
  end

  test do
    system bin/"emcc"
    assert_predicate testpath/".emscripten", :exist?, "Failed to create sample config"
  end
end
