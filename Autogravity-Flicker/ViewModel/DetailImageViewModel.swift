//
//  DetailImageViewModel.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/23/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import AlamofireImage

class DetailImageViewModel {
    let image: Image
    let name: String
    
    init(image: Image, name: String) {
        self.image = image
        self.name = name
    }
}
