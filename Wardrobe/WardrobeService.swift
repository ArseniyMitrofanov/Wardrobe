//
//  WardrobeService.swift
//  Wardrobe
//
//  Created by Арсений on 14.12.22.
//

import Foundation
import UIKit

protocol WardrobeServiceDelegate: AnyObject {// надо ли????????????????????????
   
}

class WardrobeService: NSObject {
    weak var delegate: WardrobeServiceDelegate?// надо ли??????????????????????????????????/
    static let defaultWardrobeService = WardrobeService()
    var arrayClothes: [Clothes] = [Clothes(image: UIImage(systemName: "graduationcap")!, name: "", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "1", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2f", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2rrf", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2rerecf", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2ffcv", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.hat),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "3", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.shoes),
                                   Clothes(image: UIImage(systemName: "graduationcap")!, name: "2tgref", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.shoes),
                                   Clothes(image: UIImage(systemName: "arrow.up")!, name: "4", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.outerwear),
                                   Clothes(image: UIImage(systemName: "arrow.up")!, name: "5", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.sweater),
                                   Clothes(image: UIImage(systemName: "arrow.up")!, name: "6", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.sweater),
                                   Clothes(image: UIImage(systemName: "arrow.up")!, name: "7", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.tshirt),
                                   Clothes(image: UIImage(systemName: "tshirt")!, name: "8", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.tshirt),
                                   Clothes(image: UIImage(systemName: "tshirt")!, name: "9", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.trousers),
                                   Clothes(image: UIImage(systemName: "tshirt")!, name: "0", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.trousers),
                                   Clothes(image: UIImage(systemName: "tshirt")!, name: "09", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.shoes),
                                   Clothes(image: UIImage(systemName: "tshirt")!, name: "98", description: "", temperatureLowerBound: 3.4, temperatureUpperBound: 4.5, type: Clothes.eType.shoes),]
    override init() {
        super.init()
      
    }
    
    func getClothes() -> [Clothes]{
        
        return arrayClothes
    }
    func addClothes(clothes: Clothes){
        self.arrayClothes.append(clothes)
        
    }
    func editClothes(arrayClothes: [Clothes]){
        self.arrayClothes = arrayClothes
    }
    func saveClothesArray(){
        do{
            let data = try JSONEncoder().encode(self.arrayClothes)
        }catch{
            print(error)
        }
    }
    
}
