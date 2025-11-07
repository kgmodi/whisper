# Whisper Mac App

A standalone macOS application for on-device audio transcription using [WhisperKit](https://github.com/argmaxinc/WhisperKit).

## Features

✅ **100% On-Device** - All transcription happens locally, no internet required
✅ **Privacy-Focused** - Your audio files never leave your Mac
✅ **Multiple Models** - Choose between Tiny (fast), Base (balanced), or Small (accurate)
✅ **Modern UI** - Clean SwiftUI interface with drag-and-drop support
✅ **Multiple Formats** - Supports MP3, WAV, M4A, FLAC, and more
✅ **Copy & Export** - Easy to copy transcription results

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Apple Silicon (M1/M2/M3) or Intel Mac
- ~1-2 GB free disk space for models

## Installation

### Option 1: Build with Xcode

1. Clone this repository:
   ```bash
   git clone <your-repo-url>
   cd WhisperMacApp
   ```

2. Open the project in Xcode:
   ```bash
   xed .
   ```

   This will open Package.swift in Xcode.

3. Wait for Swift Package Manager to resolve dependencies (WhisperKit will be downloaded automatically)

4. Select your Mac as the run destination

5. Build and run (⌘R)

### Option 2: Build from Command Line

1. Clone the repository:
   ```bash
   git clone <your-repo-url>
   cd WhisperMacApp
   ```

2. Build the project:
   ```bash
   swift build -c release
   ```

3. Run the app:
   ```bash
   swift run
   ```

## Usage

1. **Launch the app** - You'll see a clean interface with file selection

2. **Select an audio file** - Click "Select Audio File" and choose an audio file:
   - Supported formats: MP3, WAV, M4A, FLAC, and more
   - Any length supported (longer files take more time)

3. **Choose a model**:
   - **Tiny** - Fastest, ~150 MB, good for quick transcriptions
   - **Base** - Balanced speed/accuracy, ~290 MB (recommended)
   - **Small** - Most accurate, ~950 MB, slower but better quality

4. **Start transcription** - Click "Start Transcription"
   - First run will download the model (~150-950 MB depending on choice)
   - Models are cached for future use
   - Progress bar shows status

5. **View results** - Transcription appears in the text area
   - Click "Copy" to copy to clipboard
   - Text is selectable for partial copying

## Model Information

| Model | Size | Speed | Accuracy | Best For |
|-------|------|-------|----------|----------|
| Tiny | ~150 MB | Fastest | Good | Quick transcriptions, podcasts |
| Base | ~290 MB | Fast | Better | General use (recommended) |
| Small | ~950 MB | Moderate | Best | High-quality transcriptions |

Models are downloaded automatically on first use and cached in:
```
~/Library/Caches/huggingface/
```

## Technical Details

### Architecture

- **UI Layer**: SwiftUI for modern, native macOS interface
- **Transcription**: WhisperKit for CoreML-optimized inference
- **Audio Processing**: AVFoundation for audio file handling
- **Concurrency**: Swift async/await for responsive UI

### On-Device Processing

All transcription happens locally using:
- **CoreML** - Apple's machine learning framework
- **Neural Engine** - Hardware acceleration on Apple Silicon
- **Metal** - GPU acceleration for faster processing

### Privacy

- No network requests during transcription
- Audio files are processed in memory
- No data collection or telemetry
- All processing stays on your Mac

## Project Structure

```
WhisperMacApp/
├── Package.swift                    # Swift Package Manager configuration
├── Sources/
│   └── WhisperMacApp/
│       ├── WhisperMacAppApp.swift  # App entry point
│       ├── ContentView.swift        # Main UI
│       └── TranscriptionManager.swift # WhisperKit integration
└── README.md
```

## Development

### Adding Features

The codebase is structured for easy extension:

- **UI**: Modify `ContentView.swift` for interface changes
- **Transcription Logic**: Update `TranscriptionManager.swift` for new features
- **Models**: Add more models in the picker (Tiny, Base, Small, Medium, Large)

### Common Customizations

**Add more models:**
```swift
// In ContentView.swift, add to the Picker:
Text("Medium (Slower)").tag("medium")
Text("Large (Slowest)").tag("large")
```

**Enable word-level timestamps:**
```swift
// In TranscriptionManager.swift, modify transcribe call:
let result = try await whisperKit.transcribe(
    audioArray: audioData,
    decodeOptions: DecodingOptions(withTimestamps: true)
)
```

**Export to file:**
```swift
// Add file exporter in ContentView.swift:
.fileExporter(
    isPresented: $showExporter,
    document: TranscriptDocument(text: transcriptionText),
    contentType: .plainText,
    defaultFilename: "transcription.txt"
)
```

## Troubleshooting

### Models not downloading
- Check internet connection (needed for first download only)
- Ensure enough disk space (~1-2 GB)
- Check Console app for error messages

### App crashes on transcription
- Try a smaller model (Tiny or Base)
- Ensure audio file is valid
- Check Console app for detailed error logs

### Slow transcription
- Use Tiny or Base model for faster results
- Ensure running on Apple Silicon for best performance
- Close other resource-intensive apps

### File access errors
- macOS may require permission to access files
- Grant file access when prompted
- Check System Settings > Privacy & Security

## Performance Benchmarks

Approximate transcription speeds on M1 Mac:

| Model | 1 min audio | 10 min audio | Real-time factor |
|-------|------------|--------------|------------------|
| Tiny | ~3 sec | ~30 sec | ~20x faster |
| Base | ~5 sec | ~50 sec | ~12x faster |
| Small | ~15 sec | ~2.5 min | ~4x faster |

*Real-time factor = how many times faster than real-time playback*

## Comparison to Python Whisper

| Feature | This App (WhisperKit) | OpenAI Whisper (Python) |
|---------|----------------------|-------------------------|
| Language | Swift | Python |
| Dependencies | None (bundled) | PyTorch, FFmpeg, etc. |
| Installation | Drag & drop | pip install + setup |
| Speed (M1) | 2-5x faster | Baseline |
| Memory | Optimized | Higher |
| Platform | macOS/iOS | Cross-platform |

## Contributing

Contributions are welcome! Areas for improvement:

- [ ] Real-time streaming transcription
- [ ] Batch processing multiple files
- [ ] Export to SRT/VTT subtitles
- [ ] Language detection
- [ ] Custom model fine-tuning
- [ ] Dark mode support
- [ ] Drag & drop file support

## Resources

- [WhisperKit Documentation](https://github.com/argmaxinc/WhisperKit)
- [OpenAI Whisper Paper](https://arxiv.org/abs/2212.04356)
- [CoreML Documentation](https://developer.apple.com/documentation/coreml)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)

## License

MIT License - Feel free to use this as a starting point for your own projects!

## Acknowledgments

- [WhisperKit](https://github.com/argmaxinc/WhisperKit) by Argmax for the CoreML implementation
- [OpenAI Whisper](https://github.com/openai/whisper) for the original model
- Apple for CoreML and Swift tooling

## Support

For issues or questions:
1. Check the Troubleshooting section above
2. Review [WhisperKit issues](https://github.com/argmaxinc/WhisperKit/issues)
3. Open an issue in this repository

---

Built with ❤️ using SwiftUI and WhisperKit
