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
    fileprivate let breedNameLabel = UILabel()
    fileprivate let containerView = UIView()
    
    static let reuseId: String = "BreedCell"
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        self.breedImageView.contentMode = .scaleAspectFit
        self.breedNameLabel.textAlignment = .center
        
        self.breedNameLabel.textColor = .mainViolet()
        self.breedNameLabel.font = .avenir20()
        self.breedNameLabel.adjustsFontSizeToFitWidth = true
        self.breedNameLabel.minimumScaleFactor = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        breedImageView.image = nil
        breedNameLabel.text = nil
    }
    
    func configure(with value: BreedCellModel) {
        if let image = value.breedImages.first {
            breedImageView.image = image
        } else {
            breedImageView.image = UIImage(named: "schr-cat")
        }
        
        breedNameLabel.text = value.breed.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
}

//MARK: - Setup Constraints
extension BreedCell {
    
    fileprivate func setupConstraints() {
        breedImageView.translatesAutoresizingMaskIntoConstraints = false
        breedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(breedNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            breedImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            breedImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            breedNameLabel.topAnchor.constraint(equalTo: breedImageView.bottomAnchor),
            breedNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            breedNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            breedNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
}

