# Quick Start Guide

Get up and running with Whisper Mac App in 5 minutes!

## Prerequisites

- Mac with macOS 14.0+ (Sonoma or later)
- Xcode 15.0+ installed
- Internet connection (for first-time model download only)

## Step-by-Step Setup

### 1. Open the Project

```bash
cd WhisperMacApp
xed .
```

This opens the Swift package in Xcode.

### 2. Wait for Dependencies

Xcode will automatically:
- Resolve Swift package dependencies
- Download WhisperKit (~50 MB)
- Build the dependency graph

**This takes 1-3 minutes** depending on your internet speed.

### 3. Configure Signing (Optional for local testing)

For local development, you can run without signing:

1. In Xcode, select the WhisperMacApp target
2. Go to "Signing & Capabilities"
3. Change "Team" to your Apple ID or "Sign to Run Locally"

### 4. Build and Run

Press **⌘R** or click the Run button.

The app will:
1. Build (30-60 seconds first time)
2. Launch automatically
3. Show the main window

### 5. Try It Out

1. Click **"Select Audio File"**
2. Choose any audio file (MP3, WAV, M4A, etc.)
3. Select a model (try **Base** first)
4. Click **"Start Transcription"**

**First Run:** Will download the model (~290 MB for Base). This happens once.

**Subsequent Runs:** Uses cached model, starts immediately!

## What to Expect

### Performance

On an M1 Mac with Base model:
- **1 minute audio** → ~5 seconds transcription
- **10 minute audio** → ~50 seconds transcription
- **60 minute audio** → ~5 minutes transcription

### Model Download Sizes

First time you use each model:
- Tiny: ~150 MB download
- Base: ~290 MB download
- Small: ~950 MB download

Models are cached at:
```
~/Library/Caches/huggingface/
```

## Command Line Building (Alternative)

If you prefer the command line:

```bash
# Build
swift build -c release

# Run
swift run

# Or build and run
swift run -c release
```

## Testing Without Audio Files

Don't have audio files handy? Try these:

1. **Record with Voice Memos** (built into macOS)
2. **Use QuickTime** to record screen audio
3. **Download sample files**:
   - [Sample MP3](https://www.kozco.com/tech/organfinale.mp3) (free music)
   - Record yourself speaking

## Troubleshooting

### "Cannot find package"
- Check internet connection
- Xcode → File → Packages → Reset Package Caches

### "No code signature"
- For testing: Xcode → Signing & Capabilities → Sign to Run Locally
- For distribution: Add your Apple Developer account

### Build errors
```bash
# Clean and rebuild
swift package clean
swift build
```

### Xcode version issues
```bash
# Check Xcode version
xcodebuild -version

# Should be 15.0+
# Update via Mac App Store if needed
```

## Next Steps

Once running:

1. **Try different models** - Compare Tiny vs Base vs Small
2. **Test various audio formats** - MP3, WAV, M4A, FLAC
3. **Customize the UI** - Edit `ContentView.swift`
4. **Add features** - Check README for ideas

## Need Help?

- Check the main [README.md](README.md) for detailed docs
- Review [WhisperKit examples](https://github.com/argmaxinc/WhisperKit/tree/main/Examples)
- Open an issue if you find bugs

## What's Next?

The app is fully functional! Here are some ideas:

- [ ] Add drag-and-drop support for audio files
- [ ] Export transcriptions to .txt files
- [ ] Add subtitle export (SRT format)
- [ ] Support batch processing
- [ ] Add real-time microphone transcription
- [ ] Customize the UI theme

Happy transcribing! 🎙️
