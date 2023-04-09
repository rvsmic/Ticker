//
//  TickerSettings.swift
//  Ticker
//
//  Created by Michał Rusinek on 02/09/2022.
//

import Foundation

struct TickerSettings: Codable {
    var iconLabels: Bool
    var alternateStartScreen: Bool
    
    init(iconLabels: Bool = true, alternateStartScreen: Bool = false) {
        self.iconLabels = iconLabels
        self.alternateStartScreen = alternateStartScreen
    }
}

extension TickerSettings {
    static let sampleSettings = TickerSettings()
    static let previewSettings = TickerSettings(iconLabels: false, alternateStartScreen: true)
}
