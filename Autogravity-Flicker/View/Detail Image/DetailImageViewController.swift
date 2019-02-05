//
//  DetailImageViewController.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/20/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailImageViewController: UIViewController {
    static var storyboardId = String(describing: DetailImageViewController.self)

    // MARK: - IBOutlet
    @IBOutlet weak var recentImage: UIImageView!
    
    // MARK: - View model
    var viewModel: DetailImageViewModel!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.name
        self.recentImage.image = viewModel.image
    }
    
}
