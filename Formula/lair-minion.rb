class LairMinion < Formula
  desc "Desktop half of LAIR: bridges your local CLI coding agent to your phone"
  homepage "https://lair.mle.wtf"
  url "https://github.com/mle-wtf/lair-releases/releases/download/v26.8.5099/lair-minion-26.8.5099-macos-universal.tar.gz"
  sha256 "610a7f950712675773aca35614e7e96f74848208e79155ecd4dac31bd19ad047"
  version "26.8.5099"

  # A universal binary, so one bottle-less formula serves both arches. The
  # tarball is prebuilt because the source repo is private and brew could not
  # fetch it to build from.
  def install
    bin.install "minion" => "lair-minion"
    doc.install "README.md" if File.exist?("README.md")
  end

  # Generates the LaunchAgent, so there is no plist to hand-maintain.
  # --headless because the tray wants an app bundle and this is a bare binary;
  # under launchd there is no session to draw a status item into anyway.
  service do
    run [opt_bin/"lair-minion", "run", "--headless"]
    keep_alive true
    log_path var/"log/lair-minion.log"
    error_log_path var/"log/lair-minion.log"
  end

  def caveats
    <<~EOS
      The minion needs to be paired with your phone once before it can do
      anything. Pair it in a terminal, where it can draw the QR code:

        lair-minion pair

      Then start it in the background:

        brew services start lair-minion

      It answers through your own CLI agent, which it does not install. Point
      it at one in ~/.config/lair/minion.toml:

        agy_path = "/opt/homebrew/bin/agy"

      Without that line the minion still pairs and connects, but every message
      goes unanswered — and it says so on startup.
    EOS
  end

  test do
    # The binary prints its usage and exits 0 when given no subcommand, so this
    # asserts on content rather than on the exit status alone.
    assert_match "minion run", shell_output("#{bin}/lair-minion")
  end
end
