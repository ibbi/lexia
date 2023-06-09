//
//  API.swift
//  dyslexia
//
//  Created by ibbi on 6/9/23.
//

import Foundation

enum BackendAPIError: Error {
    case urlError
    case networkError
    case decodingError
}

struct API {
    static let assemblyURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/assembly"
    static let transformerURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/transformer"
    
    static func getAssemblyToken(completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: assemblyURL) else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(token))
        }.resume()
    }
    
    static func sendTranscribedText(_ text: String, completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: transformerURL) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["message": text])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.decodingError))
                return
            }
            
            if let transformedText = String(data: data, encoding: .utf8) {
                completion(.success(transformedText))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
