//
//  ImageCell.swift
//  iCat
//
//  Created by Stanislav Teslenko on 11.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    fileprivate let breedImageView = UIImageView()
    fileprivate let breedBlurImageView = UIImageView()
    fileprivate let containerView = UIView()
    
    static let reuseId: String = "ImageCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 7
        
        self.breedImageView.contentMode = .scaleAspectFit
        self.breedBlurImageView.contentMode = .center
        
        self.backgroundColor = .mainBGColor()
        
        self.contentMode = .scaleAspectFit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?) {
        if let image = image {
            breedImageView.image = image
            let bluredImage = image.blurImage(blurAmount: 20)
            breedBlurImageView.image = bluredImage
        } else {
            breedImageView.image = UIImage(named: "schr-cat")
        }   
    }
    
    override func prepareForReuse() {
        breedImageView.image = nil
        breedBlurImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = 6
        self.containerView.clipsToBounds = true
    }
    
}

//MARK: - Setup Constraints

extension ImageCell {
    
    fileprivate func setupConstraints() {
        
        breedImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        breedBlurImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(breedBlurImageView)
        containerView.addSubview(breedImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            breedBlurImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            breedBlurImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            breedBlurImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedBlurImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            breedImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            breedImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

    }
}
