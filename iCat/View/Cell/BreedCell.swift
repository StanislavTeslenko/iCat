//
//  BreedCell.swift
//  iCat
//
//  Created by Stanislav Teslenko on 11.04.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class BreedCell: UICollectionViewCell {

    fileprivate let breedImageView = UIImageView()
    fileprivate let breedBlurImageView = UIImageView()
    fileprivate let breedNameLabel = UILabel()
    fileprivate let nameBackgroundView = UIView()
    fileprivate let containerView = UIView()
    
    static let reuseId: String = "BreedCell"
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 7

        self.breedImageView.contentMode = .scaleAspectFit
        self.breedBlurImageView.contentMode = .center
        self.breedBlurImageView.clipsToBounds = true
        self.breedNameLabel.textAlignment = .center
        
        self.breedNameLabel.textColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        self.breedNameLabel.font = .avenir20Medium()
        self.breedNameLabel.adjustsFontSizeToFitWidth = true
        self.breedNameLabel.minimumScaleFactor = 0.5
        self.breedNameLabel.textAlignment = .center
        
        self.nameBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        breedImageView.image = nil
        breedBlurImageView.image = nil
        breedNameLabel.text = nil
    }
    
    func configure(with value: BreedCellModel) {
        
        if let image = value.breedAvatar {
            breedImageView.image = image
        } else {
            breedImageView.image = UIImage(named: "schr-cat")
        }
        
        if let image = value.breedImages.first {
            let bluredImage = image?.blurImage(blurAmount: 10)
            breedBlurImageView.image = bluredImage
        }
        
        breedNameLabel.text = value.breed.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.containerView.layer.cornerRadius = 6
        self.containerView.clipsToBounds = true
    }
    
}

//MARK: - Setup Constraints

extension BreedCell {
    
    fileprivate func setupConstraints() {
        breedImageView.translatesAutoresizingMaskIntoConstraints = false
        breedBlurImageView.translatesAutoresizingMaskIntoConstraints = false
        breedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(breedBlurImageView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(nameBackgroundView)
        containerView.addSubview(breedNameLabel)
        
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
            breedImageView.bottomAnchor.constraint(equalTo: breedNameLabel.topAnchor),
            breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nameBackgroundView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nameBackgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameBackgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            breedNameLabel.heightAnchor.constraint(equalToConstant: 40),
            breedNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            breedNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            breedNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5)
        ])
    }
}

