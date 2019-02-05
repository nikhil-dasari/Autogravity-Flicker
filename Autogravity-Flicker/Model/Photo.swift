//
//  Photo.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    
    let id: String
    let title: String
    let farm: Int
    let serverId: String
    let secret: String

    
//    init(id: String, title: String, farm: Int, serverId: String, secret: String, url: URL) {
//        self.id = id
//        self.title = title
//        self.farm = farm
//        self.serverId = serverId
//        self.secret = secret
//    }
    
    init?(json: JSON) {
        guard let id = json["id"].rawValue as? String,
            let title = json["title"].rawValue as? String,
            let farm = json["farm"].rawValue as? Int,
            let serverId = json["server"].rawValue as? String,
            let secret = json["secret"].rawValue as? String else { return nil }
        
        self.id = id
        self.title = title
        self.farm = farm
        self.serverId = serverId
        self.secret = secret
        
    }
    
    func configureImageUrl(for sizeIdentifier: String = "b") -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "farm\(self.farm).staticflickr.com"
        urlComponents.path = "/\(self.serverId)/\(self.id)_\(self.secret)_\(sizeIdentifier).jpg"
        return urlComponents.url
    }
    
}
