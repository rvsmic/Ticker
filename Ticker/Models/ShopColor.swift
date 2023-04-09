//
//  ShopColor.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

enum ShopColor: String, Codable {
    case Kaufland
    case Lidl
    case Biedronka
    case Somewhere
    case Carrefour
    case EŌLeclerc
    case Żabka
    case Stokrotka
    
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
    
    static func getShopColor (shopName: ShopName) -> Color {
        return Color(String(shopName.name + "_main").replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: ".", with: "Ō"))
    }
    
    static func getContrastShopColor (shopName: ShopName) -> Color {
        switch shopName {
        case .Kaufland, .Żabka, .Stokrotka, .Lidl, .EŌLeclerc, .Somewhere, .Carrefour, .Dino, .Aldi, .Auchan, .Delikatesy_Centrum, .ABC, .Media_Markt, .Media_Expert, .Castorama, .Leroy_Merlin, .OBI, .IKEA, .Rossmann, .Drogeria_Natura, .Drogeria_Hebe:
            return .white
        case .Biedronka, .Lewiatan, .RTV_Euro_AGD:
            return .black
        }
    }
    
    var mainColor: Color {
        Color(rawValue + "_main")
    }
    
    var accentColor: Color {
        Color(rawValue + "_accent")
    }
    
    var accentContrastColor: Color {
        switch self {
        case .Biedronka, .EŌLeclerc, .Carrefour, .Dino, .Aldi, .Auchan, .Delikatesy_Centrum, .Lewiatan, .ABC, .Leroy_Merlin, .OBI, .RTV_Euro_AGD:
            return .white
        case .Lidl, .Somewhere, .Żabka, .Stokrotka, .Kaufland, .Media_Markt, .Castorama, .Drogeria_Hebe, .Drogeria_Natura, .IKEA, .Media_Expert, .Rossmann:
            return .black
        }
    }
    
    var mainContrastColor: Color {
        switch self {
        case .Kaufland, .Żabka, .Stokrotka, .Lidl, .EŌLeclerc, .Somewhere, .Carrefour, .Dino, .Aldi, .Auchan, .Delikatesy_Centrum, .ABC, .Media_Markt, .Media_Expert, .Castorama, .Leroy_Merlin, .OBI, .IKEA, .Rossmann, .Drogeria_Natura, .Drogeria_Hebe:
            return .white
        case .Biedronka, .Lewiatan, .RTV_Euro_AGD:
            return .black
        }
    }
}
