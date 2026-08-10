class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.7.2/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "8a3421ac60480419c804d732db1e956d6a9c04109c74bba3217e58edb3bb2f13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.7.2/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "fed5fb222e87bf2a26e7deb814b851a97396e17d9449400319fc0013b6e58e88"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.7.2/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7911d05c0a84ffa3f43f9be7fa277a455b0a0bcd9568aba1901404e66c48f05b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.7.2/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "39a7dc16730c0dcb01eeaf66fdf27de2d5b12a4e813a8b5a7955884eec8d1007"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "atelier"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "atelier"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "atelier"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "atelier"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
