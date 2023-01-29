//
//  WardrobeService.swift
//  Wardrobe
//
//  Created by Арсений on 14.12.22.
//

import Foundation
import UIKit


class WardrobeService: NSObject {
    static let defaultWardrobeService = WardrobeService()
    var preferenceUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var arrayClothes: [Clothes] = []
    override init() {
        super.init()
      
    }
    
    func getClothes() -> [Clothes]{
        if arrayClothes == []{
            do{
                let pathWithFilename = preferenceUrl.appendingPathComponent("arrayClothes.json")
                arrayClothes = try JSONDecoder().decode([Clothes].self, from:FileManager.default.contents(atPath: pathWithFilename.path) ?? .init())
            }catch{
                print(error)
            }
        }
        return arrayClothes
    }
    func addClothes(clothes: Clothes){
        self.arrayClothes.append(clothes)
        saveClothesArray()
    }
    func editClothes(arrayClothes: [Clothes]){
        self.arrayClothes = arrayClothes
        saveClothesArray()
    }
    func deleteClothes(clothes: Clothes){
        
    }
    
    func saveClothesArray(){
        let q = DispatchQueue(label: "first")
        q.async {
            do{
                let pathWithFilename = self.preferenceUrl.appendingPathComponent("arrayClothes.json")
                let data = try JSONEncoder().encode(self.arrayClothes)
                try data.write(to: pathWithFilename)
            }catch{
                print(error)
            }
        }
    }
    
}
