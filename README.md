# Homebrew tap for the LAIR Minion

    brew tap mle-wtf/lair
    brew install lair-minion

The Minion is the desktop half of [LAIR](https://lair.mle.wtf): it bridges your
local CLI coding agent to the LAIR app on your phone. It is free.

After installing, pair it once in a terminal so it can draw the QR code, then
run it in the background:

    lair-minion pair
    brew services start lair-minion

The formula ships a macOS universal binary covering both Apple Silicon and
Intel. Artifacts come from [mle-wtf/lair-releases](https://github.com/mle-wtf/lair-releases).
