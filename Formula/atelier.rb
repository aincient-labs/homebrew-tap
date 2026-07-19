class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.6/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "20d50bf673499633d6a122e3209f4f76181ab7c3a5043f2c1933395d98f23883"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.6/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "dd200756017e668e3a9075d99bb7cc025d92a83e4a82dd687d8019f2aba3e42d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.6/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "87bdebf2a8152e032d54208efb5077f50488e4a6c51be79a1ae71396e3b45daa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.6/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bbb02d665ffa7bc8fa288018f67a8b7e0bfd69a62848b9c161bbcf6711893ca3"
    end
  end
  license "GPL-2.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "atelier" if OS.mac? && Hardware::CPU.arm?
    bin.install "atelier" if OS.mac? && Hardware::CPU.intel?
    bin.install "atelier" if OS.linux? && Hardware::CPU.arm?
    bin.install "atelier" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
