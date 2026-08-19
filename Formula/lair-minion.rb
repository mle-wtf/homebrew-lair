class LairMinion < Formula
  desc "Desktop half of LAIR: bridges your local CLI coding agent to your phone"
  homepage "https://lair.mle.wtf"
  url "https://github.com/mle-wtf/lair-releases/releases/download/v26.8.5099/lair-minion-26.8.5099-macos-universal.tar.gz"
  sha256 "610a7f950712675773aca35614e7e96f74848208e79155ecd4dac31bd19ad047"

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
    # Measured, not assumed: with no subcommand the binary writes its usage to
    # STDERR and exits 2. Both matter — without the redirect there is nothing on
    # stdout to match, and without the expected status shell_output raises. An
    # earlier version of this block asserted neither, because the check that
    # produced it piped through `head` and read `head`'s exit code.
    assert_match "minion run", shell_output("#{bin}/lair-minion 2>&1", 2)
  end
end
