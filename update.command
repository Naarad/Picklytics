#!/bin/bash
# Picklytics — push the latest changes so Render auto-deploys.
# Double-click after making changes to redeploy.

set -e
cd "$(dirname "$0")"

echo ""
echo "============================================"
echo "   PICKLYTICS  ·  redeploy"
echo "============================================"
echo ""

if [ ! -d .git ]; then
  echo "No git repo here. Run push-to-github.command first."
  read -p "Press Enter to close..."
  exit 1
fi

# Stage any pending changes (the file may already be committed)
git add -A

# Commit if there's something to commit
if ! git diff --cached --quiet; then
  TS=$(date +"%Y-%m-%d %H:%M")
  git -c user.email="picklytics@local" -c user.name="Picklytics" commit -m "Picklytics update — $TS"
fi

echo "Pushing to GitHub…"
echo "(If prompted, sign in with your GitHub username + the Personal Access Token)"
echo ""

git push origin main

echo ""
echo "============================================"
echo "  Pushed! Render is now building."
echo "  Watch the deploy: https://dashboard.render.com/"
echo "  Live URL: https://picklytics.onrender.com/"
echo "============================================"
echo ""
read -p "Press Enter to close..."
