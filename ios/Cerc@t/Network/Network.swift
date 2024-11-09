//
//  Network.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//


import Foundation

extension URL {
    static let serverProd = URL(string: "https://api.openai.com/v1/chat/completions")!
    static let serverDevelop = URL(string: "https://9043-83-50-214-212.ngrok-free.app/listen")!
}

enum APIErrors:Error {
    case general(Error)
    case json(Error)
    case nonHTTP
    case status(Int)
    case invalidData
    case login(String)
    
    var description:String {
        switch self {
        case .general(let error):
            return "General error \(error)."
        case .json(let error):
            return "JSON error: \(error)."
        case .nonHTTP:
            return "Non HTTP connection."
        case .status(let int):
            return "Status error: \(int)."
        case .invalidData:
            return "Invalid data."
        case .login(let reason):
            return "Login fault: \(reason)"
        }
    }
}

enum HTTPMethods:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


    
    

extension URLRequest {
    
    static func postChatAPI(url:URL = .serverProd,
                                      messages:[Message],
                                       method:HTTPMethods = .post,
                                        token:String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONEncoder().encode(AinaQuery(messages: messages))
        return request
    }
    
//    static func request(url:URL, method:HTTPMethod = .get) -> URLRequest {
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        //request.addValue("Bearer 2p0847n p", forHTTPHeaderField: "Authorization")
//        return request
//    }
//
//    static func request<T:Codable>(url:URL, method:HTTPMethod = .get, body:T) -> URLRequest {
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.httpBody = try? JSONEncoder().encode(body)
//        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        return request
//    }
    

    static func get(url:URL, token:String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = HTTPMethods.get.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func post<JSON:Codable>(url:URL, data:JSON, method:HTTPMethods = .post, token:String? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONEncoder().encode(data)
        return request
    }
}


