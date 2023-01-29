//
//  WardrobeViewController.swift
//  Wardrobe
//
//  Created by Арсений on 7.12.22.
//

import UIKit

class WardrobeViewController: UIViewController, UICollectionViewDelegate {
    var wardrobeCollectionView: UICollectionView!
    let addClothesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Загрузка ...", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 30)
        button.isEnabled = false
        return button
    }()
    
    var wardrobeDataSourse: UICollectionViewDiffableDataSource<Section, Clothes>!
    override func viewDidLoad() {
        super.viewDidLoad()
        addClothesButton.addTarget(self, action: #selector(addClothesButtonTapped), for: .touchUpInside)
        wardrobeCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateCollectionViewLayout())
        wardrobeCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        wardrobeCollectionView.delegate = self
        makeConstraints()
        createDataSource()
    }
    override func viewDidAppear(_ animated: Bool) {
    loadData()
        addClothesButton.setTitle("Добавить одежду", for: .normal)
        addClothesButton.isEnabled = true
    }
    func loadData() {
        let clothesMatrix: [[Clothes]] = getAndSortArrayClothes()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Clothes>()
        snapshot.appendSections([.hat,.outerwear,.sweater,.tshirt,.trousers,.shoes])
        snapshot.appendItems(clothesMatrix[0], toSection: .hat)
        snapshot.appendItems(clothesMatrix[1], toSection: .outerwear)
        snapshot.appendItems(clothesMatrix[2], toSection: .sweater)
        snapshot.appendItems(clothesMatrix[3], toSection: .tshirt)
        snapshot.appendItems(clothesMatrix[4], toSection: .trousers)
        snapshot.appendItems(clothesMatrix[5], toSection: .shoes)
        wardrobeDataSourse.applySnapshotUsingReloadData(snapshot)
    }
    func makeConstraints(){
        self.view.addSubview(wardrobeCollectionView)
        self.view.addSubview(addClothesButton)
        NSLayoutConstraint.activate([
            addClothesButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            addClothesButton.heightAnchor.constraint(equalToConstant: 65),
            addClothesButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            addClothesButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -22),
            wardrobeCollectionView.topAnchor.constraint(equalTo: addClothesButton.bottomAnchor, constant: 10),
            wardrobeCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            wardrobeCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            wardrobeCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    func generateCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (int: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2.5), heightDimension: .fractionalWidth(1/2))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    func createDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Clothes> { cell, indexPath, clothes in
            if !cell.subviews.isEmpty{
                cell.contentView.subviews.forEach {$0.removeFromSuperview()}
            }
            let image = UIImageView(image: clothes.image)
            image.tintColor = .red
            image.frame = cell.bounds
            cell.contentView.addSubview(image)
        
        }
        
        wardrobeDataSourse = UICollectionViewDiffableDataSource(collectionView: wardrobeCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EditClothesViewController()
        vc.indexPath = indexPath
        vc.view.backgroundColor = .white
        let backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAndSortArrayClothes() -> [[Clothes]]{
        let arrayClothes: [Clothes] = WardrobeService.defaultWardrobeService.getClothes()
        var hat: [Clothes] = []
        var outerwear: [Clothes] = []
        var sweater: [Clothes] = []
        var tshirt: [Clothes] = []
        var trousers: [Clothes] = []
        var shoes: [Clothes] = []
        
        arrayClothes.forEach { c in
            switch c.type{
            case .hat:
                hat.append(c)
            case .outerwear:
                outerwear.append(c)
            case .sweater:
                sweater.append(c)
            case .tshirt:
                tshirt.append(c)
            case .trousers:
                trousers.append(c)
            case .shoes:
                shoes.append(c)
            }
        }
        return [hat,outerwear,sweater,tshirt,trousers,shoes]
    }
    @objc func addClothesButtonTapped(){
        let vc = AddClothesViewController()
        vc.view.backgroundColor = .white
        let backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.pushViewController(vc, animated: true)
    }
    

}



