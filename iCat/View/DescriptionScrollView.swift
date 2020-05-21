//
//  DescriptionScrollView.swift
//  iCat
//
//  Created by Stanislav Teslenko on 08.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

final class DescriptionScrollView: UIScrollView {
    
    fileprivate var nameLabel: UILabel!
    fileprivate var descriptionLabel: UILabel!
    fileprivate var delimeterLabel: UILabel!
    fileprivate var temperamentLabel: UILabel!
    fileprivate var originLabel: UILabel!
    fileprivate var weightLabel: UILabel!
    fileprivate var lifespanLabel: UILabel!
    
    fileprivate var stackView: UIStackView!
    
    fileprivate var wikiButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        
        self.backgroundColor = .mainBGColor()
        
        configureElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DescriptionScrollView {
    
    fileprivate func configureElements() {
        
        nameLabel = UILabel(text: "Breed Name", font: .avenir26Medium())
        descriptionLabel = UILabel(text: "Breed Description")
        delimeterLabel = UILabel(text: "---")
        temperamentLabel = UILabel(text: "Breed Temperament")
        originLabel = UILabel(text: "Breed Origin")
        weightLabel = UILabel(text: "Breed Weight")
        lifespanLabel = UILabel(text: "Breed Lifespan")
        
        stackView = UIStackView()
            
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        delimeterLabel.translatesAutoresizingMaskIntoConstraints = false
        temperamentLabel.translatesAutoresizingMaskIntoConstraints = false
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        lifespanLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.numberOfLines = 0
        
        temperamentLabel.numberOfLines = 0
        
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(delimeterLabel)
        stackView.addArrangedSubview(temperamentLabel)
        stackView.addArrangedSubview(originLabel)
        stackView.addArrangedSubview(weightLabel)
        stackView.addArrangedSubview(lifespanLabel)
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}

extension DescriptionScrollView {
    
    func configure(with breed: BreedCellModel) {
        
        nameLabel.text = breed.breed.name
        descriptionLabel.text = breed.breed.description
        temperamentLabel.text = breed.breed.temperament
        originLabel.text = breed.breed.origin
        weightLabel.text = (breed.breed.weight?.metric ?? "n/a") + " kgs"
        lifespanLabel.text = (breed.breed.life_span ?? "n/a") + " average life span"
    }
}
