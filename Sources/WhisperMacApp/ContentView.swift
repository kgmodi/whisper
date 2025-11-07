import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var transcriptionManager = TranscriptionManager()
    @State private var selectedFileURL: URL?
    @State private var showFileImporter = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "waveform.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Whisper Transcription")
                    .font(.title)
                    .fontWeight(.bold)

                Text("On-device audio transcription powered by WhisperKit")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)

            Divider()
                .padding(.horizontal)

            // Main content area
            VStack(spacing: 16) {
                // File selection
                if let fileURL = selectedFileURL {
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundColor(.blue)
                        Text(fileURL.lastPathComponent)
                            .font(.body)
                            .lineLimit(1)
                        Spacer()
                        Button(action: {
                            selectedFileURL = nil
                            transcriptionManager.clear()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                } else {
                    Button(action: {
                        showFileImporter = true
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 40))
                            Text("Select Audio File")
                                .font(.headline)
                            Text("MP3, WAV, M4A, FLAC")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                .foregroundColor(.gray.opacity(0.3))
                        )
                    }
                    .buttonStyle(.plain)
                }

                // Model selection
                HStack {
                    Text("Model:")
                        .font(.headline)
                    Picker("", selection: $transcriptionManager.selectedModel) {
                        Text("Tiny (Fast)").tag("tiny")
                        Text("Base (Balanced)").tag("base")
                        Text("Small (Accurate)").tag("small")
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 300)
                }
                .padding(.horizontal)

                // Transcribe button
                Button(action: {
                    if let url = selectedFileURL {
                        transcriptionManager.transcribe(audioURL: url)
                    }
                }) {
                    HStack {
                        if transcriptionManager.isTranscribing {
                            ProgressView()
                                .scaleEffect(0.8)
                                .frame(width: 16, height: 16)
                        } else {
                            Image(systemName: "play.fill")
                        }
                        Text(transcriptionManager.isTranscribing ? "Transcribing..." : "Start Transcription")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedFileURL != nil && !transcriptionManager.isTranscribing ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(selectedFileURL == nil || transcriptionManager.isTranscribing)
                .buttonStyle(.plain)

                // Progress indicator
                if transcriptionManager.isTranscribing {
                    ProgressView(value: transcriptionManager.progress) {
                        Text(transcriptionManager.statusMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .progressViewStyle(.linear)
                }

                // Error message
                if let error = transcriptionManager.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }

                // Transcription result
                if !transcriptionManager.transcriptionText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Transcription Result")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(transcriptionManager.transcriptionText, forType: .string)
                            }) {
                                Label("Copy", systemImage: "doc.on.doc")
                                    .font(.caption)
                            }
                        }

                        ScrollView {
                            Text(transcriptionManager.transcriptionText)
                                .font(.body)
                                .textSelection(.enabled)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                        }
                        .frame(height: 200)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 30)

            Spacer()

            // Footer
            Text("All processing happens on-device. No internet required.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 16)
        }
        .frame(width: 600, height: 700)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.audio, .mp3, .wav, .mpeg4Audio, .m4a],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    selectedFileURL = url
                    transcriptionManager.clear()
                }
            case .failure(let error):
                transcriptionManager.errorMessage = "Failed to select file: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    ContentView()
}
