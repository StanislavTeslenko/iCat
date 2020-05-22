//
//  LoadingViewController.swift
//  iCat
//
//  Created by Stanislav Teslenko on 21.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    fileprivate var logoImageView: UIImageView!
    fileprivate var textLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainBGColor()
        
        setupElements()
        
        delay()
    }
    
    // Add loading delay
    fileprivate func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let mainVC = MainTabBarController()
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }


}

// MARK: - Setup Elements

extension LoadingViewController {
    
    private func setupElements() {
        
        let image = UIImage(named: "iCatLogo")
        logoImageView = UIImageView(image: image)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel = UILabel(text: "for MacPaw", font: .avenir26Medium())
        textLabel.textColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(textLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 130),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
   
}

// MARK: - SwiftUI
import SwiftUI

struct LoadingVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = LoadingViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<LoadingVCProvider.ContainerView>) -> LoadingViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: LoadingVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LoadingVCProvider.ContainerView>) {
            
        }
    }
}
