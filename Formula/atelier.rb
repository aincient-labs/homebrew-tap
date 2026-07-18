class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.4/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "247bc0599488a7a8dd6abb854a1eaa5cfb4ea4baadae056a4dea330aedb89ca9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.4/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "8083b73e448c8e8473bf5f525158f366d64961a53533b8d4af1f441af7c4332d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.4/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41453e860dd2ddad9691f8df867cc121d021bb6df00545f2f1196da1dc791dc8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.2.4/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f8713cb7f32f6a73546136848d424157cb551f143fd54dd3d6a0a8e06405fc8"
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
