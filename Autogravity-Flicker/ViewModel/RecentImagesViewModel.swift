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
    func viewModel(_ viewModel: RecentImagesViewModel, didGetDetailImage: Image, for indexPath: IndexPath)
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
    
    func scaledImage(forRowAt indexPath: IndexPath) -> Image? {
        guard let imageUrlAtIndexPath = recentImagesData[indexPath.row].configureImageUrl() else { return nil }
        
        if let cachedImage = cachedImage(for: imageUrlAtIndexPath) {
            let scaledImage = scaleImage(cachedImage)
            return scaledImage
        }else {
            var imageAtIndexPath: Image?
            recentImagesService.retrieveImage(for: imageUrlAtIndexPath, at: indexPath) { image in
                imageAtIndexPath = image
                let scaledImage = self.scaleImage(image)
                self.cacheImage(image, for: imageUrlAtIndexPath)
                print("seting image with downloaded image")
                self.delegate?.viewModel(self, didGetImage: scaledImage, for: indexPath)
            }
            if let _ = imageAtIndexPath {
                print("Image is available")
            }else {
                print("returning nil image")
            }
            return imageAtIndexPath
        }
        
    }
    
    func detailImage(forRowAt indexPath: IndexPath) {
        guard let imageUrlAtIndexPath = recentImagesData[indexPath.row].configureImageUrl() else { return }
        
        if let cachedImage = cachedImage(for: imageUrlAtIndexPath) {
            self.delegate?.viewModel(self, didGetDetailImage: cachedImage, for: indexPath)
        }else {
            recentImagesService.retrieveImage(for: imageUrlAtIndexPath, at: indexPath) { image in
                self.cacheImage(image, for: imageUrlAtIndexPath)
                self.delegate?.viewModel(self, didGetDetailImage: image, for: indexPath)
            }
        }
    }
    
}


//MARK: - Image Caching

extension RecentImagesViewModel {

    func cacheImage(_ image: Image, for url: URL) {
        let urlString = url.absoluteString
        print("caching the image")
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(for url: URL) -> Image? {
        let urlString = url.absoluteString
        if let cachedImage = imageCache.image(withIdentifier: urlString) {
            print("returning cached image")
            return cachedImage
        }else {
            print("Can not find the cached image for url")
            return nil
        }
       
    }
    
}
