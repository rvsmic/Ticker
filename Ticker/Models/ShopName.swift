//
//  ShopName.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

enum ShopName: String, Identifiable, CaseIterable, Codable, Comparable {
    static func < (lhs: ShopName, rhs: ShopName) -> Bool {
        if lhs.name < rhs.name {
            return true
        } else {
            return false
        }
    }
    
    case Stokrotka
    case Biedronka
    case Lidl
    case Carrefour
    case Żabka
    case Kaufland
    case EŌLeclerc
    case Somewhere
    
    case Dino
    case Aldi
    case Auchan
    case Delikatesy_Centrum
    case Lewiatan
    case ABC
    case Media_Markt
    
    case Media_Expert
    case Castorama
    case Leroy_Merlin
    case OBI
    case IKEA
    case RTV_Euro_AGD
    case Rossmann
    case Drogeria_Natura
    case Drogeria_Hebe
    
    var name: String {
        let newName = String(rawValue).replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: "Ō", with: ".")
        return newName
    }
    
    var id: String {
        name
    }
}

