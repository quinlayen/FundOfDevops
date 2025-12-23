# Git Commands - Push to GitHub and Clone on Work Computer

## First Time: Push to GitHub

### 1. Initialize Git (if not already done)
```bash
cd /path/to/FundOfDevops
git init
```

### 2. Add all files
```bash
git add .
```

### 3. Create initial commit
```bash
git commit -m "Initial commit: Part 1 and Part 2 (Bash, Ansible, Puppet) complete"
```

### 4. Create GitHub repository

Go to https://github.com/new and create a new repository named `FundOfDevops`

**Important:** Don't initialize with README (we already have files)

### 5. Add remote and push
```bash
# Replace YOUR_USERNAME with your GitHub username
git remote add origin https://github.com/YOUR_USERNAME/FundOfDevops.git

# Push to GitHub
git branch -M main
git push -u origin main
```

---

## On Work Computer: Clone and Continue

### 1. Clone the repository
```bash
cd /path/to/your/workspace
git clone https://github.com/YOUR_USERNAME/FundOfDevops.git
cd FundOfDevops
```

### 2. Verify prerequisites
```bash
vagrant --version
VBoxManage --version
```

### 3. Read the status document
```bash
# Open and read PROJECT_STATUS.md
# This tells you where we left off and what's next
```

### 4. Test one example (optional)
```bash
cd ch2/ansible
vagrant up
# Should work if Vagrant + VirtualBox are installed
vagrant destroy -f
```

### 5. Open in Claude Code

Start a new conversation with Claude Code and say:

```
I've cloned my FundOfDevops learning repository. Please read PROJECT_STATUS.md
to understand what we've completed. I'd like to continue with Packer next.
```

Claude Code will read the PROJECT_STATUS.md file and understand the full context!

---

## Ongoing: Sync Between Computers

### Before leaving home computer:
```bash
git add .
git commit -m "Describe what you added"
git push
```

### On work computer:
```bash
git pull
```

### Before leaving work computer:
```bash
git add .
git commit -m "Describe what you added"
git push
```

### Back on home computer:
```bash
git pull
```

---

## Useful Git Commands

### Check status
```bash
git status
```

### See what changed
```bash
git diff
```

### View commit history
```bash
git log --oneline
```

### Undo changes (before commit)
```bash
git checkout -- filename.md
```

### Discard all local changes
```bash
git reset --hard HEAD
```

### Create a new branch for experiments
```bash
git checkout -b experiment
# Work on experimental stuff
git checkout main  # Return to main
```

---

## .gitignore

The `.gitignore` file is already configured to exclude:
- `.vagrant/` directories
- `node_modules/`
- Terraform state files
- Packer cache
- Log files
- OS-specific files

This keeps your repository clean!

---

## Important Notes

### Conversation History Doesn't Transfer

- Git only stores **files**, not Claude Code conversation history
- `PROJECT_STATUS.md` serves as the context for new sessions
- The new Claude Code session can read PROJECT_STATUS.md to understand where you left off

### Large Files

If you accidentally create large Vagrant boxes or VirtualBox files:
- They're already in `.gitignore`
- Git will refuse to push files > 100MB
- If needed, use [Git LFS](https://git-lfs.github.com/) for large files

### Vagrant VMs Don't Transfer

- Vagrant VMs are local to each computer
- You'll need to run `vagrant up` on each machine
- The Vagrantfiles transfer, but not the actual VMs
- This is fine - VMs are disposable!

---

## Quick Reference

```bash
# Home computer - end of day
git add .
git commit -m "Progress update"
git push

# Work computer - start of day
git pull

# Work computer - end of day
git add .
git commit -m "Progress update"
git push

# Home computer - next session
git pull
```

---

## Troubleshooting

### "fatal: not a git repository"
```bash
git init
```

### "fatal: remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/FundOfDevops.git
```

### "Updates were rejected"
```bash
# Someone else (or you on another computer) pushed first
git pull
# Resolve any conflicts
git push
```

### "Authentication failed"
- Use GitHub Personal Access Token instead of password
- Or set up SSH keys: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

---

## GitHub Personal Access Token (If Needed)

If GitHub asks for password and it doesn't work:

1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Give it a name: "FundOfDevops laptop"
4. Select scopes: `repo` (full control of private repositories)
5. Click "Generate token"
6. **SAVE THE TOKEN** (you can't see it again!)
7. Use the token as your password when pushing

---

## Summary

1. **Initialize and push** from home computer
2. **Clone** on work computer
3. **Read PROJECT_STATUS.md** in new Claude Code session
4. **Continue learning** where you left off
5. **Git push/pull** to sync between computers

Easy! 🚀
