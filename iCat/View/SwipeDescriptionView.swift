//
//  SwipeDescriptionView.swift
//  iCat
//
//  Created by Stanislav Teslenko on 22.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

final class SwipeDescriptionView: UIView {
    
    fileprivate let iconImageView = UIImageView()
    fileprivate let descriptionLabel = UILabel(text: "Swipe to refresh", font: .avenir14())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
        
//        iconImageView.isHidden = true
//        descriptionLabel.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SwipeDescriptionView {
    
    private func setupElements() {
        
        iconImageView.image = UIImage(named: "pullDown")
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(iconImageView)
        self.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 35),
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        
        
    }
    
    
    
    
}
