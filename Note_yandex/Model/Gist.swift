//
//  Gist.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 06/08/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation

struct Gist: Codable {

    let  `public`: Bool
    let id: String
    let url: String
    let description: String
    let comments: Int
    let files: [String: GistFile]
    let owner: Owner
    let createdData: String
    
    private enum CodingKeys: String, CodingKey {
        case `public`
        case id
        case url
        case description
        case comments
        case files
        case owner
        case createdData = "created_at"
    }
}

struct Owner: Codable {
    
    let login: String

}

struct GistFile: Codable {

    let filename: String
    let type: String
    let rawUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case filename
        case type
        case rawUrl = "raw_url"
        
    }
}

struct PostGist: Codable {
    let  `public`: Bool
    let description: String
    let files: [String: FileGistJson]
}

struct FileGistJson: Codable {
    let  content: String
    
}
