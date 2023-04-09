//
//  ContentView.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

struct ShopsView: View {
    
    @State private var data = MultipleShops.MultipleData()
    
    @Binding var shops: [Shop]
    @State private var manageShopsViewSheetShown = false
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    @Binding var settings: TickerSettings
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            Section(header:Spacer()) {
                List {
                    ForEach($shops) { $shop in
                        NavigationLink(destination: ShopDetailView(shop: $shop, settings: $settings)) {
                            ShopCardView(shop: $shop, settings: $settings)
                        }
                        .listRowBackground($shop.items.count > 0 ? shop.color.mainColor : shop.color.mainColor.opacity(0.3))
                        .opacity($shop.items.count > 0 ? 1 : 0.3)
                    }
                }
                .modifier(ListBackgroundModifier())
            }
        }
        .navigationTitle("Shop List")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    manageShopsViewSheetShown = true
                    let multipleShops = MultipleShops(shops: shops)
                    data = multipleShops.multipleData
                }) {
                    VStack {
                        Image(systemName: "gearshape")
                        if settings.iconLabels {
                            Text("Edit")
                                .font(.caption2)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $manageShopsViewSheetShown) {
            NavigationView {
                AddShopView(data: $data, settings: $settings)
                    .navigationTitle("Manage shops")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem (placement: .cancellationAction) {
                            Button("Cancel",action: {
                                manageShopsViewSheetShown = false
                            })
                        }
                        ToolbarItem (placement: .confirmationAction) {
                            Button("Update",action: {
                                manageShopsViewSheetShown = false
                                var multipleShops = MultipleShops(shops: shops)
                                multipleShops.update(from: data)
                                shops = multipleShops.unwrap()
                                shops = shops.sorted()
                            })
                        }
                    }
            }
        }
        .tint(.primary)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ListBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopsView(shops: .constant(Shop.sampleData), saveAction: {}, settings: .constant(TickerSettings.sampleSettings))
        }
    }
}
