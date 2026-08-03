class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.10/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "6abefecebe98b55e20379542f5f4ac2d8a7db10d53fa8e29bbc3a6b3daa585e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.10/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "dc97997a247f7784313e2117a305106f57828627489cb13ad531a69b41d5eb54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.10/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a4f7d5d69fe819709169c2c0574ba6a7f540eeed4274e9c3b5313cc66b46d641"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.10/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7964f68641991f5c55bf420596e8bca49be5b7b5528dccc51173ac900a5e9d69"
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
