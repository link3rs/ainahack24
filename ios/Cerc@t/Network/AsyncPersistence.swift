//
//  AsyncPersistence.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import Foundation

final class AsyncPersistence {
    static let shared = AsyncPersistence()
    
    func postChat(conversation: [Message]) async throws -> [Message] {
        let chat = try await queryJSON(request: .postChatAPI(messages: conversation, token: .APIkey ), type: AinaResponse.self)
        if var answer = chat.choices.first?.message {
            answer = Message(role: answer.role, content: answer.content.replacingOccurrences(of:"\n",with:""))
            return conversation + [answer]
        } else {
            return conversation
        }
//        if var answer = chat.messages.first {
//            answer = Message(role: answer.role, content: answer.content.replacingOccurrences(of:"\n",with:""))
//            return conversation + [answer]
//        } else {
//            return conversation
//        }
    }
                                                                                      
    
    
    
    //MARK: - Query Function Definition
    func queryJSON<T:Codable>(request:URLRequest,
                              type:T.Type,
                              decoder:JSONDecoder = JSONDecoder(),
                              statusOK:Int = 200) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == 200 {
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIErrors.json(error)
                }
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }

    func query(request:URLRequest,
               statusOK:Int = 200) async throws -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                return true
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
    

    func save(conversation:[Message]) throws -> [Message] {
        // iOS 15, FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let saveURL = URL.documentsDirectory.appending(component: "convsersation" ).appendingPathExtension("json")
        //print(saveURL)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(conversation)
            try data.write(to: saveURL, options: [.atomic, .completeFileProtection])
            return conversation //+ [Message(role: "assistant", content: "mockup!")]
        } catch {
            throw error
        }
    }
}
