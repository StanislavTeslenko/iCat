//
//  BreedsListViewController.swift
//  iCat
//
//  Created by Stanislav Teslenko on 07.05.2020.
//  Copyright © 2020 Stanislav Teslenko. All rights reserved.
//

import UIKit

protocol BreedsListViewControllerDelegate: class {
    func sendData(breed: BreedCellModel)
}

class BreedsListViewController: UIViewController, UICollectionViewDelegate,BreedDataSourceDelegate {
    
    fileprivate var breeds: [BreedCellModel?] = []
    
    fileprivate var collectionView: UICollectionView!
    fileprivate let refreshControl = UIRefreshControl()
    
    fileprivate enum Section: Int, CaseIterable {
        case breeds
    }
    
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, BreedCellModel>!
    
    weak var delegate: BreedsListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "World of cats"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 26)!]
        
        view.backgroundColor = .mainWhite()
        
        BreedDataSource.shared.delegate = self
        
        setupNavigationController()
        setupSearchBar()
        setupCollectionView()
        
        createDatasource()
        
        loadBreedCellData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupSearchBarColors()
    }
    
    fileprivate func loadBreedCellData() {
        
        let isDataReady = BreedDataSource.shared.checkDataReady()
        
        if isDataReady != nil {
            collectionView.refreshControl?.beginRefreshing()
            breeds = BreedDataSource.shared.getBreedCellData()
            reloadData(with: nil)
        }
    }
    
    @objc fileprivate func pullToRefreshData() {
        
        let isDataReady = BreedDataSource.shared.checkDataReady()
        
        if isDataReady == nil || isDataReady == true {
            collectionView.refreshControl?.beginRefreshing()
            BreedDataSource.shared.getBreedsListApiData()
        }
    }
    
    func refreshCells() {
        breeds = BreedDataSource.shared.getBreedCellData()
        reloadData(with: nil)
    }
    
    func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func loadingError() {
        loadingAlert()
    }
    
    fileprivate func loadingAlert() {
        let alertController = UIAlertController(title: "Sorry!", message: "We can't load breeds list :( Please check the internet connection and try again!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.collectionView.refreshControl?.endRefreshing()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Setup Elements

extension BreedsListViewController {
    
    fileprivate func setupNavigationController() {
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    fileprivate func setupSearchBar() {
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupSearchBarColors() {
        
        let searchController = navigationItem.searchController!
        
        // Setup searchBar indicator color
        searchController.searchBar.tintColor = .mainViolet()
        // Setup searchBar search text and placeholder color
        searchController.searchBar.searchTextField.textColor = .mainViolet()
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search breed", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7311726613, green: 0.6135759854, blue: 0.9686274529, alpha: 1)])
        // Setup searchBar left search icon color
        searchController.searchBar.searchTextField.leftView?.tintColor = .mainViolet()
        // Setup searchBar right clear button icon
        let clearButton = searchController.searchBar.searchTextField.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .mainViolet()
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        collectionView.alwaysBounceVertical = true
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(pullToRefreshData), for: .valueChanged)
        refreshControl.tintColor = .mainViolet()
        
        view.addSubview(collectionView)
        
        collectionView.register(BreedCell.self, forCellWithReuseIdentifier: BreedCell.reuseId)

        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewCompositionalLayout
extension BreedsListViewController {
    
    fileprivate func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {fatalError("Unknown section")}
            
            switch section {
            case .breeds:
                return self.createBreedSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    fileprivate func createBreedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    
        return section
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension BreedsListViewController {
    fileprivate func createDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, BreedCellModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .breeds:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedCell.reuseId, for: indexPath) as? BreedCell else {
                    fatalError("Unable to dequeue cell type")
                }
                cell.configure(with: item)
                return cell
            }
        })
    }
    
    fileprivate func reloadData(with searchText: String?) {
        
        var breedArray = breeds.compactMap{$0}.sorted(by: {$1.breed.name! > $0.breed.name!})
        
        if searchText != nil && searchText != "" {
        breedArray = breedArray.filter ({ (breed) in
            return Bool((breed.breed.name?.contains(searchText!))!)
        })
        }
  
        var snapshot = NSDiffableDataSourceSnapshot<Section, BreedCellModel>()
        snapshot.appendSections([.breeds])
        snapshot.appendItems(breedArray, toSection: .breeds)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UISearchBarDelegate
extension BreedsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    
}

// MARK: - UICollectionViewDelegate
extension BreedsListViewController {

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = self.dataSource?.itemIdentifier(for: indexPath) else {return}

        present(BreedDetailViewController(with: item), animated: true) {
            let presentedVC = self.presentedViewController as? BreedDetailViewController
            self.delegate = presentedVC
            self.delegate?.sendData(breed: item)
        }
    }

}

