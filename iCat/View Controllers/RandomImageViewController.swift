//
//  RandomImageViewController.swift
//  iCat
//
//  Created by Stanislav Teslenko on 01.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class RandomImageViewController: UIViewController, RandomImageDataSourceDelegate {
    
    fileprivate let dataSource = RandomImageDataSource()
    fileprivate var imageScrollView: ImageScrollView!
    fileprivate let swipeDescriptionView = SwipeDescriptionView()
    fileprivate var recivedImage: UIImage!
    fileprivate var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Random cat"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MainTextColor")!, NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 24)!]
        
        view.backgroundColor = .mainBGColor()
        
        setupAuxElements()
        
        //        Add ImageScrollView class into view and configure it
        setupImageScrollView()
        
        //        Add RefreshControl action into ImageScrollView class
        imageScrollView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.imageScrollView.refreshControl?.beginRefreshing()
        
        //        Configure datasource and load data from API
        dataSource.delegate = self
        dataSource.loadNetworkData()
        
    }
    
//MARK: - RefreshControl action
    
    @objc fileprivate func refresh(_ sender: AnyObject) {
        dataSource.loadNetworkData()
        swipeDescriptionView.isHidden = true
    }
    
//    MARK: - Alert Controller
    
    fileprivate func loadingAlert() {
        let alertController = UIAlertController(title: "Sorry!", message: "We can't load the cat's image :( Please check the internet connection and try again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            //    Stop RefreshControl
            self.imageScrollView.refreshControl?.endRefreshing()
            self.swipeDescriptionView.isHidden = false
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
  

// MARK: - Setup Elements

extension RandomImageViewController {
    
    fileprivate func setupAuxElements() {
        
        swipeDescriptionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(swipeDescriptionView)
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            swipeDescriptionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -10),
            swipeDescriptionView.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
//            swipeDescriptionView.heightAnchor.constraint(equalToConstant: 40),
//            swipeDescriptionView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }
    
    //    Setup ImageScrollView
    fileprivate func setupImageScrollView() {
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageScrollView)
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: margins.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: swipeDescriptionView.topAnchor, constant: -10),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
    
//MARK: - RandomImageDataSourceDelegate
    
extension RandomImageViewController {
    
    func dataReady(image: UIImage?) {
        
        // Loaded data processing
        if let image = image {
            self.recivedImage = image
            isLoaded = true
            //    Stop RefreshControl
            self.imageScrollView.refreshControl?.endRefreshing()
            swipeDescriptionView.isHidden = false
        } else {
            loadingAlert()
            if !isLoaded {
                self.recivedImage = UIImage(named: "schr-cat")
            }
        }
        // Transfer loaded image into ImageScrollView
        imageScrollView.set(image: self.recivedImage)
    }
}


