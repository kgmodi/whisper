import Foundation
import WhisperKit
import AVFoundation

@MainActor
class TranscriptionManager: ObservableObject {
    @Published var transcriptionText: String = ""
    @Published var isTranscribing: Bool = false
    @Published var progress: Double = 0.0
    @Published var statusMessage: String = ""
    @Published var errorMessage: String?
    @Published var selectedModel: String = "base"

    private var whisperKit: WhisperKit?
    private var currentModelName: String = ""

    func transcribe(audioURL: URL) {
        Task {
            isTranscribing = true
            errorMessage = nil
            transcriptionText = ""
            progress = 0.0

            do {
                // Load model if needed
                if whisperKit == nil || currentModelName != selectedModel {
                    statusMessage = "Loading \(selectedModel) model..."
                    progress = 0.1

                    let modelVariant = selectedModel
                    whisperKit = try await WhisperKit(
                        computeOptions: .init(
                            audioEncoderCompute: .cpuAndGPU,
                            textDecoderCompute: .cpuAndGPU
                        ),
                        verbose: true,
                        logLevel: .info
                    )

                    currentModelName = selectedModel
                    progress = 0.3
                }

                // Ensure we have access to the file
                guard audioURL.startAccessingSecurityScopedResource() else {
                    throw NSError(domain: "TranscriptionError", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Unable to access the selected file"])
                }
                defer {
                    audioURL.stopAccessingSecurityScopedResource()
                }

                statusMessage = "Loading audio file..."
                progress = 0.4

                // Load audio using AVAudioFile
                let audioData = try loadAudioData(from: audioURL)

                statusMessage = "Transcribing audio..."
                progress = 0.5

                // Transcribe
                guard let whisperKit = whisperKit else {
                    throw NSError(domain: "TranscriptionError", code: 2,
                                userInfo: [NSLocalizedDescriptionKey: "WhisperKit not initialized"])
                }

                let transcriptionResult = try await whisperKit.transcribe(
                    audioArray: audioData
                )

                progress = 0.9

                // Extract text from result
                if let segments = transcriptionResult?.segments {
                    transcriptionText = segments.map { $0.text }.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                } else if let text = transcriptionResult?.text {
                    transcriptionText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                } else {
                    transcriptionText = "No transcription available"
                }

                statusMessage = "Transcription complete!"
                progress = 1.0

                // Clear status after a delay
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                if !isTranscribing {
                    statusMessage = ""
                }

            } catch {
                errorMessage = "Transcription failed: \(error.localizedDescription)"
                print("Transcription error: \(error)")
            }

            isTranscribing = false
        }
    }

    func clear() {
        transcriptionText = ""
        errorMessage = nil
        progress = 0.0
        statusMessage = ""
    }

    private func loadAudioData(from url: URL) throws -> [Float] {
        // Load audio file using AVAudioFile
        let audioFile = try AVAudioFile(forReading: url)

        guard let format = AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 16000,
            channels: 1,
            interleaved: false
        ) else {
            throw NSError(domain: "AudioError", code: 3,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to create audio format"])
        }

        let converter = AVAudioConverter(from: audioFile.processingFormat, to: format)
        guard let converter = converter else {
            throw NSError(domain: "AudioError", code: 4,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to create audio converter"])
        }

        let frameCount = UInt32(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: AVAudioFrameCount(audioFile.length)
        ) else {
            throw NSError(domain: "AudioError", code: 5,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to create PCM buffer"])
        }

        var error: NSError?
        converter.convert(to: buffer, error: &error) { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return audioFile.read(into: buffer)
        }

        if let error = error {
            throw error
        }

        // Convert to Float array
        guard let channelData = buffer.floatChannelData?[0] else {
            throw NSError(domain: "AudioError", code: 6,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to extract audio data"])
        }

        let audioArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
        return audioArray
    }
}
