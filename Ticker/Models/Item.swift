//
//  Item.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import Foundation

struct Item: Identifiable, Codable, Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        if lhs.name < rhs.name {
            return true
        } else {
            return false
        }
    }
    
    let id: UUID
    var name: String
    var count: Int
    var isBought: Bool
    var additionalNote: String
    
    init(id: UUID = UUID(), name: String, count: Int, isBought: Bool = false, additionalNote: String = "") {
        self.id = id
        self.name = name
        self.count = count
        self.isBought = isBought
        self.additionalNote = additionalNote
    }
}

extension Item {
    static let sampleData = [
        Item(name: "Chleb", count: 1, isBought: true, additionalNote: "Z koszyczka"),
        Item(name: "Piwo", count: 4, additionalNote: "Perła w promocji"),
        Item(name: "Ser", count: 1, isBought: true),
        Item(name: "Masło", count: 2),
        Item(name: "Woda", count: 6)
    ]
}

extension Item {
    static func countBought (items: [Item]) -> Int {
        var count = 0
        for item in items {
            if item.isBought == true {
                count+=1
            }
        }
        return count
    }
}

struct MultipleItems {
    var items: [Item]
    
    init(items: [Item]) {
        self.items = items
    }
    
    mutating func update(from multipleData: MultipleData) {
        items = multipleData.items
    }
    
    func unwrap() -> [Item] {
        return items
    }
}

extension MultipleItems {
    struct MultipleData {
        var items: [Item] = Item.sampleData
        
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
    
    var multipleData: MultipleData {
        MultipleData(items: items)
    }
}

extension MultipleItems {
    static let sampleData: MultipleItems = MultipleItems(items: Item.sampleData)
}
