//
//  Picture.swift
//  Consolidation5
//
//  Created by Yuki Shinohara on 2020/05/28.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class Picture: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

