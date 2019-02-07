//
//  RecentImagesService.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/23/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class RecentImagesService {
    
    fileprivate var dataRequests: [IndexPath: DataRequest] = [:]
    
    fileprivate var flickerRecentImagesUrl: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest/"
        
        // Query Items
        let method = URLQueryItem.init(name: "method", value: "flickr.photos.getRecent")
        let key = URLQueryItem.init(name: "api_key", value: "fee10de350d1f31d5fec0eaf330d2dba")
        let format = URLQueryItem.init(name: "format", value: "json")
        let noJsonCallback = URLQueryItem.init(name: "nojsoncallback", value: "true")
        
        urlComponents.queryItems = [method, key, format, noJsonCallback]
        return urlComponents.url
    }
    
    fileprivate func getImageUrlWith(id: String, title:String, farm: Int, serverId: String, secret: String) -> URL? {
        let size = "b"
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "farm\(farm).staticflickr.com"
        urlComponents.path = "/\(serverId)/\(id)_\(secret)_\(size).jpg"
        return urlComponents.url
    }
    
    fileprivate func parseResponseJson(_ json: [JSON]) -> [Photo] {
        var photos: [Photo] = []
        for photoItem in json {
            if let photo = Photo(json: photoItem) {
              photos.append(photo)
            }
        }
        return photos
    }
    
    func getRecentImages(completionHandler: @escaping ([Photo]) -> ()) {
        // get the url
        guard let url = flickerRecentImagesUrl else {
            print("Please check Flicker Url for recent images")
            return
        }

        Alamofire.request(url).validate().responseJSON { response in
            guard let responseData = JSON(response.value as Any)["photos"]["photo"].array else { return }
            let photos = self.parseResponseJson(responseData)
            DispatchQueue.main.async {
                 completionHandler(photos)
            }
           
        }
    }
    
    func retrieveImage(for url: URL, at indexPath: IndexPath, completionHandler: @escaping (Image) -> ()) {
        
        if let dataRequest = dataRequests[indexPath] {
            print("cancelled")
            dataRequest.cancel()
        }
        
        let request = Alamofire.request(url).validate().responseImage { response in
            switch response.result {
            case .failure(let error):
                print("Failed to retreive image, error description: \(error.localizedDescription)")
            case .success(let image):
                DispatchQueue.main.async {
                    completionHandler(image)
                }
            }
        }
        
        dataRequests[indexPath] = request
    }
    
}
