#!/bin/bash
# Picklytics — one-shot GitHub push.
# 1. Create an empty repo on github.com (no README, no .gitignore, no license)
# 2. Copy the HTTPS clone URL (looks like https://github.com/USERNAME/Picklytics.git)
# 3. Double-click this file, paste the URL when asked.

set -e
cd "$(dirname "$0")"

echo ""
echo "============================================"
echo "   PICKLYTICS  ·  push to GitHub"
echo "============================================"
echo ""

if ! command -v git >/dev/null 2>&1; then
  echo "Git is not installed. Install it via Xcode Command Line Tools:"
  echo "  xcode-select --install"
  read -p "Press Enter to close..."
  exit 1
fi

# Init if needed
if [ ! -d .git ]; then
  git init -b main >/dev/null 2>&1 || git init >/dev/null 2>&1
  # Make sure branch is main
  git symbolic-ref HEAD refs/heads/main 2>/dev/null || true
fi

# Stage + commit (only if there are changes)
git add .
if ! git diff --cached --quiet; then
  git -c user.email="picklytics@local" -c user.name="Picklytics" commit -m "Initial Picklytics deploy"
else
  echo "Nothing new to commit (already up to date locally)."
fi

# Repo URL
echo ""
echo "Paste your GitHub repo URL (e.g. https://github.com/yourname/Picklytics.git)"
echo "or git@github.com:yourname/Picklytics.git"
read -p "Repo URL: " REPO_URL

if [ -z "$REPO_URL" ]; then
  echo "No URL provided. Aborting."
  read -p "Press Enter to close..."
  exit 1
fi

# Set / replace origin
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REPO_URL"
else
  git remote add origin "$REPO_URL"
fi

# Ensure main branch
git branch -M main 2>/dev/null || true

echo ""
echo "Pushing to $REPO_URL …"
echo "(If prompted, sign in with your GitHub credentials. For HTTPS, use a"
echo " Personal Access Token instead of your password — github.com/settings/tokens)"
echo ""

git push -u origin main

echo ""
echo "============================================"
echo "  Done! Your code is on GitHub."
echo "  Next: connect this repo to Render."
echo "============================================"
echo ""
read -p "Press Enter to close..."
