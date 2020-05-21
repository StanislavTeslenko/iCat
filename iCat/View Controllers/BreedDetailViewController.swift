//
//  BreedDetailViewController.swift
//  iCat
//
//  Created by Stanislav Teslenko on 08.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

class BreedDetailViewController: UIViewController {
    
    var breed: BreedCellModel!
    
    var collectionView: UICollectionView!
    var descriptionView: DescriptionScrollView!
    
    enum Section: Int, CaseIterable {
        case breedImages
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, UIImage>!
    
    var isInitImage: Bool = true
    
    convenience init(with breed: BreedCellModel) {
        self.init()
        self.breed = breed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mainBGColor()
        
        setupDragView()
        setupCollectionView()
        setupDescriptionView()
        createDatasource()
        reloadData()
        descriptionView.configure(with: breed)
        loadBreedImages()
    }
    
    private func loadBreedImages() {
        BreedDataSource.shared.getBreedImages(breed: breed) { (loadedImage) in
            
            guard let loadedImage = loadedImage else {return}
            
            if self.isInitImage {
                self.breed.breedImages.removeAll()
                self.isInitImage = false
            }
            
            self.breed.breedImages.append(loadedImage)
            self.reloadData()
            
        }
    }

}

// MARK: - Setup Elements
extension BreedDetailViewController {
    
    private func setupDragView() {
        
        let dragView = UIView()
     
        let width: CGFloat = view.bounds.width / 4
        dragView.layer.cornerRadius = 3
        dragView.backgroundColor = .mainTextColor()
        dragView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(dragView)
        
        dragView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12).isActive = true
        dragView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
        dragView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        dragView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainBGColor()
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseId)
        
        view.addSubview(collectionView)
        
        let margins = view.layoutMarginsGuide
        
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 32).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
    }
    
    private func setupDescriptionView() {
        
        descriptionView = DescriptionScrollView(frame: view.frame)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.backgroundColor = .mainBGColor()

        view.addSubview(descriptionView)
        
        let margins = view.layoutMarginsGuide
        
        descriptionView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
        descriptionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        descriptionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        descriptionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        descriptionView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
    }
    
}

// MARK: - BreedsListViewControllerDelegate
extension BreedDetailViewController: BreedsListViewControllerDelegate {
    
    func sendData(breed: BreedCellModel) {
        self.breed = breed
    }
  
}

// MARK: - UICollectionViewCompositionalLayout
extension BreedDetailViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {fatalError("Unknown section")}
            
            switch section {
            case .breedImages:
                return self.createBreedImageSection()
            }
        }
        
        return layout
    }
    
    private func createBreedImageSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }

}

// MARK: - UICollectionViewDiffableDataSource
extension BreedDetailViewController {
    private func createDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .breedImages:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseId, for: indexPath) as? ImageCell else {
                    fatalError("Unable to dequeue cell type")
                }
                cell.configure(with: item)
                cell.layoutIfNeeded()
                return cell
            }
        })
    }
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapshot.appendSections([.breedImages])
        
        for image in breed.breedImages {
            if let image = image {
                    snapshot.appendItems([image], toSection: .breedImages)
                    dataSource?.apply(snapshot, animatingDifferences: true)
            }
        }
    }
}

