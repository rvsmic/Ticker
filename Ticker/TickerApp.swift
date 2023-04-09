//
//  TickerApp.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

@main
struct TickerApp: App {
    @StateObject private var shopStore = ShopStore()
    @State private var errorWrapper: ErrorWrapper?
    
    @StateObject private var itemStore = ItemStore()
    
    @StateObject private var settingsStore = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                StartView(items: $itemStore.items, shops: $shopStore.shops, settings: $settingsStore.settings) {
                    ItemStore.save(items: itemStore.items) { result in
                        Task {
                            do {
                                try await ItemStore.save(items: itemStore.items)
                            } catch {
                                errorWrapper = ErrorWrapper(error: error, guidance: "Error saving Simple Mode data. Try again later.")
                            }
                        }
                    }
                } shopsSaveAction: {
                    ShopStore.save(shops: shopStore.shops) { result in
                        Task {
                            do {
                                try await ShopStore.save(shops: shopStore.shops)
                            } catch {
                                errorWrapper = ErrorWrapper(error: error, guidance: "Error saving Shop mode data. Try again later.")
                            }
                        }
                    }
                } settingsSaveAction: {
                    SettingsStore.save(settings: settingsStore.settings) { result in
                        Task {
                            do {
                                try await SettingsStore.save(settings: settingsStore.settings)
                            } catch {
                                errorWrapper = ErrorWrapper(error: error, guidance: "Error saving settings. Try again later.")
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(.stack) //zaskakująco naprawia wszystkie cofnięcia ?
            .task {
                do {
                    itemStore.items = try await ItemStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Error loading Simple Mode data. Sample data will be loaded.")
                }
            }
            .task {
                do {
                    shopStore.shops = try await ShopStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Error loading data. Sample data will be loaded.")
                }
            }
            .task {
                do {
                    settingsStore.settings = try await SettingsStore.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Error loading settings. Default settings will be loaded.")
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                itemStore.items = Item.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            .sheet(item: $errorWrapper, onDismiss: {
                shopStore.shops = Shop.sampleData
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            .sheet(item: $errorWrapper, onDismiss: {
                settingsStore.settings = TickerSettings.sampleSettings
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}
