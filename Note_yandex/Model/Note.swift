//
//  Note.swift
//  YaNote
//
//  Created by Denis Evdokimov on 26/06/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation
import UIKit

enum  Important:String, Codable {
    case unimportant = "unimportant"
    case normal = "normal"
    case critical = "critical"    
}

struct Note {
   
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Important
    let selfDestructionDate: Date?

    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = .white,
         important: Important,
         destructionDate: Date? = nil) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = important
        self.selfDestructionDate = destructionDate
    }
    func compare(with note: Note) -> Bool {
        if self.uid == note.uid &&
            self.title == note.title &&
            self.content == note.content &&
            self.color == note.color &&
            self.importance.rawValue == note.importance.rawValue &&
            self.selfDestructionDate == note.selfDestructionDate {
                return true
            }
        return false
    }
}

