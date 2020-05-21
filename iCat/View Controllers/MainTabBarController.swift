//
//  MainTabBarController.swift
//  iCat
//
//  Created by Stanislav Teslenko on 04.04.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .mainViolet()
        
        let randomImageViewController = RandomImageViewController()
        let breedsListViewController = BreedsListViewController()
        
        let randomImage = UIImage(named: "random-regular")!
        let breedImage = UIImage(named: "breeds-regular")!
        
        viewControllers = [generateNavigationController(rootViewController: randomImageViewController, title: "Random", image: randomImage),
        generateNavigationController(rootViewController: breedsListViewController, title: "Breeds", image: breedImage)]
    }
}

extension MainTabBarController {
    
    fileprivate func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
