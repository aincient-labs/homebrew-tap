class Atelier < Formula
  desc "The `atelier` command — install, update, back up, and manage your Atelier CMS appliance."
  homepage "https://github.com/aincient-labs/manager"
  version "0.13.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.13.1/atelier-aarch64-apple-darwin.tar.xz"
      sha256 "ae15e70954166e1ba07bd5c1467d83e2ae4da4e3fd4f6616606ea2fc10290a42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.13.1/atelier-x86_64-apple-darwin.tar.xz"
      sha256 "e38a624522b6d24a7fde445d075cc013d1b6ef76f2fd2f83197acbb0dc6e0e14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/aincient-labs/manager/releases/download/v0.13.1/atelier-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb836e66fd6d93020faa3eb468485d49f667d34b97155cd090039869be9f47a8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/aincient-labs/manager/releases/download/v0.13.1/atelier-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c16825e8c6b039cbc9f6e5718fa9cec1559ed7e5c3219b5e6a9c6b26ca52384a"
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
