//
//  ViewController.swift
//  Wardrobe
//
//  Created by Арсений on 26.11.22.
//

import UIKit

class ViewController: UIViewController{
    let model = Model()
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewController = self
        model.getLocation()
        
        
    }
 
}
