//
//  Сlothes.swift
//  Wardrobe
//
//  Created by Арсений on 7.12.22.
//

import Foundation
import UIKit

struct Clothes: Hashable, Codable {
    var image: UIImage
    var name: String
    var description: String
    var temperatureLowerBound : Double
    var temperatureUpperBound : Double
    var type: eType
    
    enum CodingKeys: String, CodingKey {
        case image
        case name
        case description
        case temperatureLowerBound
        case temperatureUpperBound
        case type
    }
    enum eType: String, Codable{
        case hat
        case outerwear
        case sweater
        case tshirt
        case trousers
        case shoes
    }
}
