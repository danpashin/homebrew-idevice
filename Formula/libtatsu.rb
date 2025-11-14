class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  version "1.0.5"
  url "https://github.com/futurerestore/libtatsu/archive/refs/tags/#{version}.tar.gz"
  sha256 "2235740da2c5095ba1c6d010e3bdaa76e224d8e811e55a993f030257291508ac"
  license "LGPL-2.1-or-later"
  head "https://github.com/futurerestore/libtatsu.git", branch: "master"

  keg_only "it can conflict with homebrew/core"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  def install
    (buildpath/".tarball-version").write "#{version}"

    system "./autogen.sh", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libtatsu/tss.h"

      int main(int argc, char* argv[]) {
        tss_set_print_tss_request(0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
