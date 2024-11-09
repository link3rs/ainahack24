//
//  Models.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import SwiftUI

extension String? {
    static let APIkey = "sk-Zz6B-------------------APeciwH"
}

// MARK: - AinaQuery
struct AinaQuery: Codable {
    var model = "gpt-4o-mini"
    let messages: [Message]
}

// MARK: - Message
struct Message: Codable, Identifiable, Hashable {
    let id = UUID()
    let role:String
    let content:String

    enum CodingKeys: String, CodingKey {
        case role, content
    }
}
//struct AinaResponse: Codable {
//    var model: String
//    let messages: [Message]
//}

// MARK: - AinaResponse
struct MatchaVocosQuery: Codable {
    let text: String
    let speakerId: Int // 7 //let voice: String // valencia/gina
    let cleaner: String? // "catalan_balear_cleaners"  []
    let lengthScale: Float //0.8
    let temperature: Float // 0.7
    
    enum CodingKeys: String, CodingKey {
        case cleaner, temperature, text //, usage
        case lengthScale = "length_scale"
        case speakerId = "speaker_id"
    }
    
}


//enum Cleaner: Codable {
//    case balear  //catalan_balear_cleaners
//    case central    // catalan_cleaners(default)
//    case nord_occidental   // catalan_occidental_cleaners
//    case valencia    // catalan_valencia_cleaners
//}
struct AinaResponse: Codable { //chatGPT
    let id, object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}


// MARK: - Choice
struct Choice: Codable { //posibilidad de mas de una respuesta, por eso lo del array
    let index: Int
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct SpeechQuery: Codable {
    let text: String
    let voice: String
    let voiceName: String

    enum CodingKeys: String, CodingKey {
        case text, content
        case voiceName = "voice_name"
    }
}

// MARK: - Usage
struct Usage: Codable {
    let promptTokens, completionTokens, totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
    
    
 
}
// */
