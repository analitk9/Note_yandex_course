//
//  NoteExtension.swift
//  YaNote
//
//  Created by Denis Evdokimov on 26/06/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        if let jsonUid = json["uid"] as? String,
            let jsonTitle = json["title"] as? String,
            let jsonContent = json["content"] as? String {
            var destructionDate: Date?
            
            if let jsontsDate = json["selfDestructionDate"] as? TimeInterval {
                destructionDate =  Date(timeIntervalSince1970: jsontsDate)
            }
            
            var important: Important?
            if let jsonImportant = json["importance"] as? String {
                important = Important.init(rawValue: jsonImportant)
            }
            
            var color: UIColor?
            if let jsonColor = json["color"] as? [String: CGFloat] {
                color = Note.getColor(with: jsonColor)
            }
            
            return Note(uid: jsonUid,
                        title: jsonTitle,
                        content: jsonContent,
                        color: color ?? UIColor.white,
                        important: important ?? .normal,
                        destructionDate: destructionDate)
            
        }else  {
            return nil
        }
        
    }
    
    var json: [String: Any]  {
        var js: [String: Any] = [:]
        js["uid"] = self.uid
        js["title"] = self.title
        js["content"] = self.content
        if let dat = self.selfDestructionDate {
            js["selfDestructionDate"] = dat.timeIntervalSince1970
        }
        if self.importance != .normal {
            js["importance"] = self.importance.rawValue
        }
        if self.color != .white {
            js["color"] = Note.getRGBA(color: self.color)
        }
        return js
    }
    
    static private func getRGBA (color: UIColor) -> [String: CGFloat] {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return ["r": r, "g": g, "b": b, "a": a]
    }
    
    static private func getColor (with rgbaDict: [String: CGFloat]) -> UIColor {
        return  UIColor(red: rgbaDict["r"]! , /// 255.0
                        green: rgbaDict["g"]!,/// 255.0
                        blue: rgbaDict["b"]! ,/// 255.0
                        alpha: rgbaDict["a"]!)
    }
    
}

extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uid == rhs.uid 
    }
}
