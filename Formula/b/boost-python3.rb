class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2"
  sha256 "430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "01c318b0959055451680bb0f268d6a3883eb97ae57fce9c6efcb7bc550ff2df7" => :mojave
    sha256 "fb53abe8982598f1185ac2e2c9c8fe2af23f77ec942f8c3add04302f2ee788fd" => :high_sierra
    sha256 "ee6c8454ca2405f0a14db7148869cdbccd9976cd40493dd1fade680849d8b845" => :sierra
  end

  depends_on "boost"
  depends_on "python"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2d/80/1809de155bad674b494248bcfca0e49eb4c5d8bee58f26fe7a0dd45029e2/numpy-1.15.4.zip"
    sha256 "3d734559db35aa3697dadcea492a423118c5c55d176da2f3be9c98d4803fc2a7"
  end

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged-1.66",
            "--user-config=user-config.jam",
            "threading=multi,single",
            "link=shared,static"]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    numpy_site_packages = buildpath/"homebrew-numpy/lib/python#{pyver}/site-packages"
    numpy_site_packages.mkpath
    ENV["PYTHONPATH"] = numpy_site_packages
    resource("numpy").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"homebrew-numpy")
    end

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using darwin : : #{ENV.cxx} ;
      using python : #{pyver}
                   : python3
                   : #{py_prefix}/include/python#{pyver}m
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python3",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3", "--stagedir=stage-python3",
                   "python=#{pyver}", *args

    lib.install Dir["stage-python3/lib/*py*"]
    doc.install Dir["libs/python/doc/*"]
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS

    pyincludes = Utils.popen_read("python3-config --includes").chomp.split(" ")
    pylib = Utils.popen_read("python3-config --ldflags").chomp.split(" ")
    pyver = Language::Python.major_minor_version("python3").to_s.delete(".")

    system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}", "-o",
           "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output("python3", output, 0)
  end
end
