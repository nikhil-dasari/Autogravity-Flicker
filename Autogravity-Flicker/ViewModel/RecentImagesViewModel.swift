//
//  RecentImagesViewModel.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/20/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit
import AlamofireImage

protocol RecentImagesViewModelDelegate: class {
    func reloadViewController()
    func viewModel(_ viewModel: RecentImagesViewModel, didGetImage image: Image, for indexPath: IndexPath)
}

class RecentImagesViewModel {
    fileprivate var recentImagesData: [Photo] = []
    fileprivate let recentImagesService = RecentImagesService()
    weak var delegate: RecentImagesViewModelDelegate?
    var tappedImageNameLabel: String?
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: 150_000_000,
        preferredMemoryUsageAfterPurge: 60_000_000
    )
    
    init() {
        recentImagesService.getRecentImages { photos in
            self.recentImagesData = photos
            self.delegate?.reloadViewController()
        }
    }
    
}

// MARK: - Public apis

extension RecentImagesViewModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return self.recentImagesData.count
    }
    
    func title(forRowAt indexPath: IndexPath) -> String {
        return self.recentImagesData[indexPath.row].title
    }
    
    fileprivate func scaleImage(_ image: Image, to size: CGSize = CGSize(width: 60.0, height: 60.0)) -> Image {
        return image.af_imageScaled(to: size)
    }
    
    func imageUrl(at indexPath: IndexPath) -> URL? {
        return recentImagesData[indexPath.row].configureImageUrl()
    }
    
}


//MARK: - Image Caching

extension RecentImagesViewModel {

    func cacheImage(_ image: Image, for url: URL) {
        let urlString = url.absoluteString
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(for url: URL) -> Image? {
        let urlString = url.absoluteString
        return imageCache.image(withIdentifier: urlString)
    }
    
}
