//
//  DocumentModel.swift
//  KekaDemo
//
//  Created by Webappclouds on 26/09/24.
//

import Foundation

struct DocumentModel: Codable {
    let response: Response
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
    }
}

struct Response: Codable {
    let doc: [ResponseModel]
    
    enum CodingKeys: String, CodingKey {
        case doc = "docs"
    }
}

struct ResponseModel: Codable, Identifiable {
    let abstract: String
    let webUrl: String
    let multimedia: [MultiMedia]
    let id: UUID = UUID()
    
    enum CodingKeys: String, CodingKey {
        case abstract = "abstract"
        case webUrl = "web_url"
        case multimedia = "multimedia"
    }
}

struct MultiMedia: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
