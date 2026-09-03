class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.9.1/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "97a7caf9debf76b07040e4b552b5c7d599054ddf806bd3009b6a508aa98708c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.9.1/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "297f75b55ffbf2656dbc13966c3ff2d38bbc6cf03f51f19d06b3073822401839"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.9.1/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "afa4ec73a107177e5a755f319dffadc2f8585de26b395fab76fd9ca244f09006"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.9.1/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bc31d3e7697a67dc6b9ec23c8a7068aacb7c92e0b95c481a6b2443b7b0281966"
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
