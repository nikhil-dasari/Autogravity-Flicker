//
//  RecentImagesViewController.swift
//  Autogravity-Flicker
//
//  Created by Nikhil Dasari on 1/21/19.
//  Copyright © 2019 Nikhil. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

class RecentImagesViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tappedImageNameLabel: UILabel!
    
    // MARK: - View model
    
    lazy var recentImagesViewModel: RecentImagesViewModel = {
        let vm = RecentImagesViewModel()
        vm.delegate = self
        return vm
    }()
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tappedImageName = recentImagesViewModel.tappedImageNameLabel {
            tappedImageNameLabel.text = tappedImageName
        }
    }
    
}

// MARK: - Table view data source

extension RecentImagesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.recentImagesViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentImagesViewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentImagesTableViewCell.cellId, for: indexPath) as! RecentImagesTableViewCell
        cell.configure(delegate: self, name: self.recentImagesViewModel.title(forRowAt: indexPath))
        if let url = recentImagesViewModel.imageUrl(at: indexPath) {
             cell.recentImageButton.af_setImage(for: .normal, url: url)
        }
       
        return cell
    }
    
}

// MARK: - Navigation

extension RecentImagesViewController: RecentImagesTableViewCellDelegate {
    func recentImagesTableViewCell(_ cell: RecentImagesTableViewCell, imageDidTapped image: UIImage, name: String) {
        let detailImageViewModel = DetailImageViewModel(image: image, name: name)
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: DetailImageViewController.storyboardId) as! DetailImageViewController
        detailVC.viewModel = detailImageViewModel
        recentImagesViewModel.tappedImageNameLabel = name
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - RecentImagesViewModelDelegate

extension RecentImagesViewController: RecentImagesViewModelDelegate {
    func reloadViewController() {
        self.loadingIndicatorView.stopAnimating()
        tableView.reloadData()
    }
    
    func viewModel(_ viewModel: RecentImagesViewModel, didGetImage image: UIImage, for indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RecentImagesTableViewCell else { return }
        cell.recentImageButton?.setImage(image, for: .normal)
    }
    
}
