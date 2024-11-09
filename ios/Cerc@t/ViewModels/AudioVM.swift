//
//  AudioVM.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//
    
import SwiftUI
import AVFoundation

final class AudioVM: ObservableObject {
    let persistence = AsyncPersistence.shared
    
    @Published var isRecording = false
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession!
    private var chunkDuration: Int = 6
    private var timer: Timer?
    private var currentChunkIndex = 0
    private var audioFilename: URL?
    private var isMicrophoenAvailable = false
    
    
    // MARK: - Public Methods
    
    func startRecord(time: Int) {
        self.chunkDuration = time
        self.isRecording = true
        self.currentChunkIndex = 0
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .granted:
            isMicrophoenAvailable = true
        case .denied:
            isMicrophoenAvailable = false
        case .undetermined:
            // Request permission
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                self.isMicrophoenAvailable = granted  // Handle the response
            }
        @unknown default:
            // Handle future cases
            break
        }
        guard isMicrophoenAvailable else {
            return
        }
        
        Task {
            await self.startRecordingSession()
            self.startTimer()
        }
    }
    
    func stopRecord() {
        isRecording = false
        timer?.invalidate()
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    // MARK: - Private Methods
    
    
    private func startRecordingSession() async {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self?.startNewRecordingChunk()
                    } else {
                        // Handle permission denied
                    }
                }
            }
        } catch {
            // Handle errors
        }
    }
    
    private func startNewRecordingChunk() {
        currentChunkIndex += 1
        audioFilename = getDocumentsDirectory().appendingPathComponent("recording\(currentChunkIndex).wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM), // WAV format
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
            //audioRecorder?.delegate = self
            audioRecorder?.record(forDuration: TimeInterval(chunkDuration))
        } catch {
            // Handle recording error
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(chunkDuration), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.isRecording {
                self.audioRecorder?.stop()
                self.startNewRecordingChunk()
            } else {
                self.timer?.invalidate()
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func sendAudioToAPI(fileURL: URL) async {
        let apiURL = URL(string: "https://l9w4uzm374uyn9xk.us-east-1.aws.endpoints.huggingface.cloud")!
        let bearerToken = "hf_Ajz-------------------------HRPudwA"

        do {
            // Read the audio file data
            let audioData = try Data(contentsOf: fileURL)

            // Create the URLRequest
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            request.setValue("audio/wav", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            request.httpBody = audioData

            // Send the request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check the HTTP response status
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response from server")
                return
            }

            if httpResponse.statusCode == 200 {
                // Parse the JSON response
                guard let response = try? JSONDecoder().decode(WishperReponse.self, from: data) else {
                    print("Failed to parse transcript from response")
                    return
                }
                let transcript = response.text
                
                // Handle the transcript (e.g., update your UI or model)
                DispatchQueue.main.async {
                    print("Transcript: \(transcript)")
                    // Update your published properties or UI here
                }
             
            } else {
                // Handle HTTP errors
                print("Server returned status code \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            }
        } catch {
            // Handle errors
            print("Error sending audio to API: \(error.localizedDescription)")
        }
    }
    
    struct WishperReponse: Codable {
        let text: String
    }
    
//    private func sendAudioToAPI(fileURL: URL) async {
//        // Implement your API call here using async/await
//        // For example:
//        do {
//            let data = try Data(contentsOf: fileURL)
//            // Prepare your URLRequest and send the data
//            // Handle the response
//        } catch {
//            // Handle errors
//        }
//    }
}

// MARK: - AVAudioRecorderDelegate

//extension AudioViewModel: AVAudioRecorderDelegate {
//    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        if flag, let url = audioFilename {
//            Task {
//                await sendAudioToAPI(fileURL: url)
//            }
//        }
//    }
//}
