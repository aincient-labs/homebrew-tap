class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.11.1/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "723551f4a2cfefe6316ee976328af1eca98a1d0c274d4d12cfa79bc0475f0656"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.11.1/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "f677a6c3328a6d175926b6d3c1abfcdc533c570120be33f9822a331f9bf3e526"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.11.1/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ac9adbf87a8a2d704b61ceea1ef4d5b57e7d86661187758066a4140143ff051"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.11.1/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b600a264d4c62e566fb90835a14327ab7da7012e970f6f81d7531bd8d4f0b5e0"
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
