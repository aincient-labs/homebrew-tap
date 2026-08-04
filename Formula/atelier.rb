class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.3.0/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "cc710ccce6a1b4b82780ef22c509a4805f690758468d95584c7557ea894ab858"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.3.0/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "48be8c17d209ae99dda446566d1fbdd01ca7fa1062f8a49af1eb83c49d8a668e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.3.0/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8c2ed9d8e79bc2d7376aa9e583fd1c248ef600c3e7a6e4025307988141e5167"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.3.0/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "59bf82a3a08e059f9ac693033c6aeaabc95c13b72c5dedd73b61a94f0b0dcd3e"
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
