//
//  ImageService.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 23/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

class ImageService {
    
    // MARK: - Singletone instance
    
    static var shared = ImageService()
    private init() {
        // Set default images
        let images = ["screen_1", "screen_2", "screen_3", "screen_4", "screen_5"]
        for name in images {
            guard let image = UIImage(named: name) else { continue }
            self.images.append(image)
        }
    }
    
    // MARK: - Properties
    
    private(set) var images = [UIImage]()
    
    // MARK: - Data management
    
    func add(image: UIImage) {
        images.append(image)
    }
    
}
