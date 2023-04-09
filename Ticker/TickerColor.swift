//
//  TickerColor.swift
//  Ticker
//
//  Created by Michał Rusinek on 28/08/2022.
//

import SwiftUI

enum TickerColor: String {
    case OuterAccentColor
    case InnerAccentColor
    
    var name: String {
        rawValue
    }
    
    var color: Color {
        Color(rawValue)
    }
}
