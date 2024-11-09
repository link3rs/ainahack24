//
//  SpeakVM.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import Foundation
import AVFoundation

final class SpeakVM: ObservableObject {
    
    let API_URL = "https://p1b28cv1e843tih1.eu-west-1.aws.endpoints.huggingface.cloud/api/tts"
    let headers = [
        "Authorization": "Bearer hf_Ajz---------------HRPudwA"
    ]
    
    // Diccionari de veus amb accent i nom associat a cada ID
//    let availableVoices: [Int: [String: String]] = [
//        0: ["name": "quim", "accent": "balear"],
//        1: ["name": "olga", "accent": "balear"],
//        2: ["name": "grau", "accent": "central"],
//        3: ["name": "elia", "accent": "central"],
//        4: ["name": "pere", "accent": "nord-occidental"],
//        5: ["name": "emma", "accent": "nord-occidental"],
//        6: ["name": "lluc", "accent": "valencia"],
//        7: ["name": "gina", "accent": "valencia"]
//    ]
    
    func selectVoiceId() -> Int {
        print("Tria una veu:")
        for (voiceId, voiceInfo) in availableVoices {
            if let name = voiceInfo["name"], let accent = voiceInfo["accent"] {
                print("ID: \(voiceId) - Nom: \(name) - Accent: \(accent)")
            }
        }
        
        while true {
            print("Introdueix l'ID de la veu desitjada: ", terminator: "")
            if let input = readLine(), let voiceId = Int(input), availableVoices.keys.contains(voiceId) {
                return voiceId
            } else {
                print("ID invàlid. Torna-ho a intentar.")
            }
        }
    }
    
    func query(text: String, voiceId: Int) -> Data? {
        guard let voiceInfo = availableVoices[voiceId],
              let voiceName = voiceInfo["name"],
              let voiceAccent = voiceInfo["accent"] else {
            return nil
        }
        
        
        
        var request = URLRequest(url: URL(string: API_URL)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = try? JSONSerialization.data(withJSONObject: data)
        
        let semaphore = DispatchSemaphore(value: 0)
        var responseData: Data?
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            responseData = data
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return responseData
    }
    
    // Exemple d'ús
    let textInput = "Bon dia Mercè, avui fa bon dia al Priorat. Gracies per la teva recerca."
    let voiceId = selectVoiceId()  // Demanem l'ID de veu a l'usuari
    
    // Guardem l'àudio
    if let response = query(text: textInput, voiceId: voiceId) {
        let outputPath = "output.wav"
        do {
            try response.write(to: URL(fileURLWithPath: outputPath))
            print("Àudio desat a \(outputPath)")
            
            // Reproduïm l'àudio desat
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: outputPath))
            player.play()
            print("Reproduint l'àudio...")
        } catch {
            print("Error al guardar o reproduir l'àudio: \(error)")
        }
    } else {
        print("Error en la consulta a l'API.")
    }
}
