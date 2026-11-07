class Lair < Formula
  desc "Desktop half of LAIR: bridges your local CLI coding agent to your phone"
  homepage "https://lair.mle.wtf"
  url "https://github.com/mle-wtf/lair-releases/releases/download/v26.11.1832/lair-macos-universal.tar.gz"
  version "26.11.1832"
  sha256 "97c3a283ba09531f1c6c21fe9cb6a8271362a31550b2bacc6a7ac07003d89cad"

  # A universal binary, so one bottle-less formula serves both arches. The
  # tarball is prebuilt because the source repo is private and brew could not
  # fetch it to build from. Renamed from lair-minion (formula_renames.json).
  def install
    bin.install "lair"
    doc.install "README.md" if File.exist?("README.md")
  end

  # Generates the LaunchAgent, so there is no plist to hand-maintain.
  # --headless because the tray wants an app bundle and this is a bare binary;
  # under launchd there is no session to draw a status item into anyway.
  service do
    run [opt_bin/"lair", "run", "--headless"]
    keep_alive true
    log_path var/"log/lair.log"
    error_log_path var/"log/lair.log"
  end

  def caveats
    <<~EOS
      The minion needs to be paired with your phone once before it can do
      anything. Pair it in a terminal, where it can draw the QR code:

        lair pair

      Then start it in the background:

        brew services start lair

      It answers through your own CLI agent, which it does not install. Point
      it at one in ~/.config/lair/minion.toml:

        agy_path = "/opt/homebrew/bin/agy"

      Without that line the minion still pairs and connects, but every message
      goes unanswered — and it says so on startup.
    EOS
  end

  test do
    # A bare `lair` is the chat and fails without a terminal; an unknown verb
    # prints the usage to STDERR and exits 2.
    assert_match "lair run", shell_output("#{bin}/lair help 2>&1", 2)
  end
end
