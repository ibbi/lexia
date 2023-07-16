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
    static let transformerURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/transform"
    static let generatorURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/generate"
    static let whisperURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/whisper"
    static let editURL = "https://basic-bundle-long-queen-51be.ibm456.workers.dev/edit"

    
    static func sendTextForZap(_ text: String, completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: transformerURL) else {
            completion(.failure(.urlError))
            return
        }
        
        let prompt = UserDefaults(suiteName: "group.lexia")?.string(forKey: "zap_mode_id") ?? "0"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["prompt": prompt, "message": text])
        
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
    
    
    static func generateText(completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: generatorURL) else {
            completion(.failure(.urlError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.decodingError))
                return
            }
            
            if let generatedText = String(data: data, encoding: .utf8) {
                completion(.success(generatedText))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    static func sendAudioForTranscription(audioURL: URL, completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: whisperURL) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: audioURL))
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError))
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let text = json["text"] as? String {
                        completion(.success(text))
                    } else {
                        completion(.failure(.decodingError))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    static func sendAudioAndTextForEdit(audioURL: URL, contextText: String, completion: @escaping (Result<String, BackendAPIError>) -> Void) {
        guard let url = URL(string: editURL) else {
            completion(.failure(.urlError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: audioURL))
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"context\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(contextText)\r\n".data(using: .utf8)!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
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
