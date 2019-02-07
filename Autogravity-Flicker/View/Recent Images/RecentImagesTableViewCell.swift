//
//  RecentImagesTableViewCell.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit

protocol RecentImagesTableViewCellDelegate: class {
    func recentImagesTableViewCell(_ cell: RecentImagesTableViewCell, imageDidTapped image: UIImage, name: String)
    func recentImagesTableViewCell(_cell: RecentImagesTableViewCell, tappedImageAt indexPath: IndexPath)
}

class RecentImagesTableViewCell: UITableViewCell {
    static var cellId = String(describing: RecentImagesTableViewCell.self)

    @IBOutlet weak var recentImageButton: UIButton!
    @IBOutlet weak var recentImageTitleLabel: UILabel!
    
    weak var delegate: RecentImagesTableViewCellDelegate?
    var indexPath: IndexPath?
    
    @IBAction func tappedOnImage(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        guard let image = self.recentImageButton.imageView?.image else { return }
        guard let name = self.recentImageTitleLabel.text else { return }
        //delegate.recentImagesTableViewCell(self, imageDidTapped: image, name: name)
        if let indexPath = indexPath {
            delegate.recentImagesTableViewCell(_cell: self, tappedImageAt: indexPath)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.indexPath = nil
    }
    
    func configure(delegate: RecentImagesViewController, name: String, indexPath: IndexPath) {
        self.recentImageTitleLabel.text = name
        self.delegate = delegate
        self.indexPath = indexPath
    }
}
