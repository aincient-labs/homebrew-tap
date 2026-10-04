class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.12.0/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "07e7ad8b1401d046a8b8f25b4e050af106efda0611e06d9c7afc59c3d431c5b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.12.0/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "a23d62158c379ac6dd51043fd4d537fd45e08a1fbc7451d264dacf1960e804b2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.12.0/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ff7804d4c8b7883809b92b3119d83fab9a99b7274b662ffb798d17d8a1ec28f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.12.0/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "29803f58ef9327eb6db69352d6ddc24332c5e9ff7476eb75bdfd99239eacfc75"
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
