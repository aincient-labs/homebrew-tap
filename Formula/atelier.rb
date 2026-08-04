class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.4.0/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "c3d0965cfe88a1d6afe68eb9be8fdfe7632d1e684c6ef5d571393bf0b55b94ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.4.0/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "2dc52e5849572bd3332f4c15a34bef890e1ccf2866012b6665508b5153b7a230"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.4.0/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0c5818c528228e0de49b1359e7bae0f765488b301fce0fe08336999b6d1df0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.4.0/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5b5edaab4b485d6e3b078ab0b1e416be48dda78ac7ec284d5625a8ef03b074a"
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
