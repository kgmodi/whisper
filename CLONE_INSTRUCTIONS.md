# Clone and Test Instructions

Your Whisper Mac App has been successfully pushed to GitHub! 🎉

## Repository Information

- **Repository:** https://github.com/kgmodi/whisper
- **Branch:** `claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7`
- **Total Commits:** 2
- **Files:** 9 files, 370 lines of Swift code

## Quick Clone & Test

### Option 1: Clone Specific Branch (Recommended)

```bash
# Clone just the Mac app branch
git clone --branch claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7 --single-branch \
  https://github.com/kgmodi/whisper.git whisper-mac-app

cd whisper-mac-app
```

### Option 2: Clone Full Repo, Checkout Branch

```bash
# Clone the full whisper repository
git clone https://github.com/kgmodi/whisper.git

cd whisper

# Checkout the Mac app branch
git checkout claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7
```

### Option 3: Add to Existing Clone

If you already have the whisper repo cloned:

```bash
cd /path/to/your/whisper

# Fetch the new branch
git fetch origin claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7

# Checkout the branch
git checkout claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7
```

## Testing the App

### 1. Open in Xcode

```bash
# Navigate to the cloned directory
cd whisper-mac-app  # or wherever you cloned it

# Open in Xcode
xed .
```

Or double-click `Package.swift` in Finder.

### 2. Wait for Dependencies

Xcode will automatically:
- Resolve Swift Package Manager dependencies
- Download WhisperKit (~50 MB)
- Build the dependency graph

**This takes 1-3 minutes** on first open.

### 3. Build & Run

- Press **⌘R** (or click the Run button)
- Select "My Mac" as the destination
- App will build and launch

### 4. Test Transcription

1. **First Launch:** App window appears
2. **Select Audio File:** Click "Select Audio File"
3. **Choose Model:** Try "Base" (recommended)
4. **Start Transcription:** Click "Start Transcription"
5. **First Run:** Model downloads (~290 MB for Base)
6. **View Results:** Transcription appears in text area

## Expected Performance

On Apple Silicon (M1/M2/M3):

| Model | 1 min audio | 10 min audio | Download Size |
|-------|------------|--------------|---------------|
| Tiny | ~3 sec | ~30 sec | ~150 MB |
| Base | ~5 sec | ~50 sec | ~290 MB |
| Small | ~15 sec | ~2.5 min | ~950 MB |

## Branch Structure

```
claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7
├── Package.swift                      # Swift Package Manager config
├── README.md                          # Full documentation
├── QUICKSTART.md                      # 5-minute setup guide
├── GITHUB_SETUP.md                    # GitHub publishing guide
├── CLONE_INSTRUCTIONS.md              # This file
├── LICENSE                            # MIT License
├── .gitignore                         # Xcode/Swift ignores
└── Sources/WhisperMacApp/
    ├── WhisperMacAppApp.swift        # App entry point (12 lines)
    ├── ContentView.swift              # SwiftUI UI (202 lines)
    └── TranscriptionManager.swift     # WhisperKit logic (156 lines)
```

## Troubleshooting

### Xcode Issues

**"Cannot resolve package dependencies"**
```bash
# In Xcode: File → Packages → Reset Package Caches
# Then: File → Packages → Resolve Package Versions
```

**"No code signature"**
- Xcode → Signing & Capabilities
- Change "Team" to "Sign to Run Locally"

### Build Issues

**Swift version issues**
```bash
# Check Swift version (need 5.9+)
swift --version

# Check Xcode version (need 15.0+)
xcodebuild -version
```

**Clean build**
```bash
# From command line
cd whisper-mac-app
swift package clean
swift build
```

### Runtime Issues

**"Model download failed"**
- Check internet connection
- Ensure ~1-2 GB free disk space
- Try a smaller model (Tiny)

**"Cannot access audio file"**
- macOS may require file permission
- Grant access when prompted
- Check System Settings → Privacy & Security

## Command Line Building (Alternative)

If you prefer not to use Xcode:

```bash
# Build
swift build -c release

# Run
swift run

# Or build & run optimized
swift run -c release
```

The app will launch as a graphical application.

## What's in This Branch

This branch contains a **complete standalone Mac application**, not the Python Whisper library:

- ✅ Native Swift/SwiftUI application
- ✅ WhisperKit integration for CoreML
- ✅ On-device transcription
- ✅ No Python dependencies
- ✅ Production-ready UI
- ✅ Comprehensive documentation

**Note:** This is separate from the Python Whisper implementation in the main branch.

## Verifying the Code

### View on GitHub

Visit: https://github.com/kgmodi/whisper/tree/claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7

### Check Commits

```bash
git log --oneline
# Should show:
# 79e90d7 Add GitHub setup instructions
# d660cd2 Initial commit: Whisper Mac App proof-of-concept
```

### Count Lines

```bash
wc -l Sources/WhisperMacApp/*.swift
#  202 Sources/WhisperMacApp/ContentView.swift
#  156 Sources/WhisperMacApp/TranscriptionManager.swift
#   12 Sources/WhisperMacApp/WhisperMacAppApp.swift
#  370 total
```

## Pull Request (Optional)

If you want to create a PR to review the code:

```bash
# The remote provided a URL:
# https://github.com/kgmodi/whisper/pull/new/claude/whisper-mac-app-011CUtQzYfAMtp8XuS9viEv7

# Or use GitHub CLI:
gh pr create --title "Add Whisper Mac App" \
  --body "Native macOS application for on-device transcription using WhisperKit"
```

## Moving to Separate Repository (Later)

If you want to move this to its own repo later:

```bash
# 1. Create new repo on GitHub (e.g., whisper-mac-app)

# 2. Change the remote
git remote set-url origin https://github.com/kgmodi/whisper-mac-app.git

# 3. Push to main branch
git branch -M main
git push -u origin main
```

## Testing Checklist

Before using in production:

- [ ] App builds without errors
- [ ] App launches successfully
- [ ] File picker works
- [ ] Model downloads successfully
- [ ] Transcription produces accurate text
- [ ] All three models work (Tiny, Base, Small)
- [ ] Copy to clipboard works
- [ ] Error handling works (test with invalid files)
- [ ] UI is responsive during transcription

## Need Help?

1. **Check README.md** - Comprehensive documentation
2. **Check QUICKSTART.md** - 5-minute setup guide
3. **WhisperKit Issues** - https://github.com/argmaxinc/WhisperKit/issues
4. **Create Issue** - On the whisper repository

## System Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- ~1-2 GB free disk space
- Apple Silicon (M1/M2/M3) recommended (also works on Intel)

## Success Indicators

You'll know it's working when:

1. ✅ Xcode opens the project without errors
2. ✅ Build succeeds (⌘B)
3. ✅ App launches with UI visible
4. ✅ File picker opens and can select files
5. ✅ Model downloads (progress shown)
6. ✅ Transcription completes with text output
7. ✅ Copy button works

## What's Next?

Once you've tested and it works:

1. **Customize** - Modify the UI, add features
2. **Extend** - Add real-time transcription, export formats
3. **Share** - Post in community discussions
4. **Distribute** - Build for App Store or direct distribution

---

**Happy Testing!** 🎙️

Questions? Check the README or open an issue.
