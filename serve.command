#!/bin/bash
# Picklytics — local server launcher.
# Double-click this file on macOS to start a server, then open the printed URL.

cd "$(dirname "$0")"

PORT=8000

echo ""
echo "============================================"
echo "   PICKLYTICS  ·  local server"
echo "============================================"
echo ""
echo "  Open on this Mac:"
echo "    http://localhost:${PORT}"
echo ""

IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || ipconfig getifaddr en2 2>/dev/null)
if [ -n "$IP" ]; then
  echo "  On iPhone (same Wi-Fi):"
  echo "    http://${IP}:${PORT}"
  echo ""
  echo "  NOTE: iOS Safari blocks the camera on plain http://."
  echo "  Options for iPhone:"
  echo "    • Easiest:  Open this Mac's browser at http://localhost:${PORT}"
  echo "    • For phone: run an HTTPS tunnel, e.g.:"
  echo "                 cloudflared tunnel --url http://localhost:${PORT}"
  echo "                 ngrok http ${PORT}"
  echo "                Then open the https:// URL it prints, on your iPhone."
fi

echo ""
echo "  Press Ctrl-C to stop."
echo "============================================"
echo ""

# Try python3, fall back to python
if command -v python3 >/dev/null 2>&1; then
  python3 -m http.server "$PORT"
elif command -v python >/dev/null 2>&1; then
  python -m SimpleHTTPServer "$PORT"
else
  echo "Python is required to run the local server."
  echo "Install Python from https://www.python.org/ and try again."
  read -p "Press Enter to close..."
fi
