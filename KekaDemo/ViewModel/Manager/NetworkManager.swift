//
//  NetworkLayer.swift
//  KekaDemo
//
//  Created by Webappclouds on 26/09/24.
//

import Foundation

protocol NetworkService {
    func fetchDocument<T: Decodable>() async throws -> T
}

class NetworkManager: NetworkService {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchDocument<T: Decodable>() async throws -> T {
        guard let url = URL(string: "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=election&api-key=j5GCulxBywG3lX211ZAPkAB8O381S5SM") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw error
        }
    }
}

