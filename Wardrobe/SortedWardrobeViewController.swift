//
//  ViewController.swift
//  Wardrobe
//
//  Created by Арсений on 27.01.23.
//

import UIKit

class SortedWardrobeViewController: WardrobeViewController {
    var currentTemperature: Double = 0
    let dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("\\/", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .red
        button.titleLabel?.font =  .systemFont(ofSize: 30)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
      
    }
    override func makeConstraints() {
        self.view.addSubview(wardrobeCollectionView)
        self.view.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 65),
            dismissButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            dismissButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -22),
            wardrobeCollectionView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 10),
            wardrobeCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            wardrobeCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            wardrobeCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    override func getAndSortArrayClothes() -> [[Clothes]] {
        let arrayClothes: [Clothes] = WardrobeService.defaultWardrobeService.getClothes()
        var hat: [Clothes] = []
        var outerwear: [Clothes] = []
        var sweater: [Clothes] = []
        var tshirt: [Clothes] = []
        var trousers: [Clothes] = []
        var shoes: [Clothes] = []
        
        arrayClothes.forEach { c in
            if  (c.temperatureLowerBound <= currentTemperature)&&(c.temperatureUpperBound >= currentTemperature){
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
        }
        return [hat,outerwear,sweater,tshirt,trousers,shoes]
    }
    @objc func dismissButtonTapped(){
        self.dismiss(animated: true)
    }
}
