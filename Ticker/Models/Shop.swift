//
//  Shop.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import Foundation
import SwiftUI

struct Shop: Identifiable, Codable, Comparable {
    static func < (lhs: Shop, rhs: Shop) -> Bool {
        if lhs.name.name < rhs.name.name {
            return true
        }
        else {
            return false
        }
            
    }
    
    static func == (lhs: Shop, rhs: Shop) -> Bool {
        if lhs.name.name == rhs.name.name {
            return true
        }
        else {
            return false
        }
    }
    
    let id: UUID
    var name: ShopName
    var color: ShopColor
    var items: [Item]
    
    init(id: UUID = UUID(), name: ShopName, color: ShopColor = .Somewhere, items: [Item] = []){
        self.id = id
        self.name = name
        self.color = ShopColor(rawValue: name.rawValue)!
        self.items = items
    }
    
    func boughtCount() -> Int {
        var boughtCount = 0
        for item in items {
            if item.isBought == true {
                boughtCount+=1
            }
        }
        return boughtCount
    }
}

extension Shop {
    struct Data {
        var name: ShopName = .Somewhere
        var color: ShopColor = .Somewhere
        var items: [Item] = []
        
        mutating func deleteItem(deleteItem: Item) {
            var i = 0
            for item in items {
                if item == deleteItem {
                    items.remove(at: i)
                }
                i+=1
            }
        }
        
    }
    
    var data: Data {
        Data(name: name, color: color, items: items)
    }
    
}

extension Shop {
    mutating func update(from data: Data) {
        name = data.name
        color = data.color
        items = data.items
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        color = data.color
        items = data.items
    }
}

struct MultipleShops {
    var shops: [Shop]
    
    init(shops: [Shop]) {
        self.shops = shops
    }
    
    mutating func update(from multipleData: MultipleData) {
        shops = multipleData.shops
    }
    
    func unwrap() -> [Shop] {
        return shops
    }
}

extension MultipleShops {
    struct MultipleData {
        var shops: [Shop] = Shop.sampleData
        
        mutating func deleteShop(deleteShop: Shop) {
            var i = 0
            for shop in shops {
                if shop == deleteShop {
                    shops.remove(at: i)
                }
                i+=1
            }
        }
    }
    
    var multipleData: MultipleData {
        MultipleData(shops: shops)
    }
}

extension Shop {
    static let sampleData: [Shop] = [
        Shop(name: .Stokrotka, items: Item.sampleData),
        Shop(name: .Żabka),
        Shop(name: .Lidl),
        Shop(name: .EŌLeclerc, items: Item.sampleData)
    ]
}

extension MultipleShops {
    static let sampleData: MultipleShops = MultipleShops(shops: Shop.sampleData)
}
