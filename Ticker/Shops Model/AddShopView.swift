//
//  AddShopView.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

struct AddShopView: View {
    
    @Binding var data: MultipleShops.MultipleData
    
    @State private var newShop: ShopName = .ABC
    @State private var recentlyAddedShop: ShopName?
    @State private var showDeleteAlert = false
    
    @Binding var settings: TickerSettings
    
    var body: some View {
        Form {
            Section(header: Text("Enable shops")){
                Picker("New shop", selection: $newShop) {
                    ForEach(ShopName.allCases.filter { shopName in
                        return !data.shops.map { shop in
                            shop.name
                        }.contains(shopName)
                    }.sorted(), id: \.self) { shop in
                        ZStack {
                            Capsule()
                                .fill(ShopColor.getShopColor(shopName: shop))
                            Text(shop.name)
                                .foregroundColor(ShopColor.getContrastShopColor(shopName: shop))
                                .font(.headline)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .font(.headline)
                .labelsHidden()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            data.shops.append(Shop(name: newShop))
                            recentlyAddedShop = newShop
                        }
                    }) {
                        VStack {
                            Image(systemName: "plus")
                                .font(.title.bold())
                            if settings.iconLabels {
                                Text("Add")
                                    .font(.caption2)
                            }
                        }
                        .foregroundColor(ShopColor.getContrastShopColor(shopName: newShop))
                    }
                    Spacer()
                }
                .listRowBackground(ShopColor.getShopColor(shopName: newShop))
            }
            Section (header: HStack{ Text("Enabled shops"); Spacer(); Button(action: {
                showDeleteAlert = true
            }) {
                VStack {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.headline)
                    if settings.iconLabels {
                        Text("Clear")
                            .font(.caption2)
                    }
                }
            }}) {
                ForEach(data.shops) {shop in
                    HStack {
                        Text("\(shop.name.name)")
                            .font(.headline)
                        Spacer()
                        ZStack {
                            Capsule()
                                .fill(shop.color.mainColor)
                            Image(systemName: "circle.fill")
                                .foregroundColor(shop.color.accentColor)
                                .padding(5)
                        }
                        .fixedSize()
                    }
                    .padding(.vertical,5)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                data.deleteShop(deleteShop: shop)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        .tint(.red)
                    }
                }
            }
        }
        .alert("Clear all shops?", isPresented: $showDeleteAlert) {
            Button("Confirm", role: .destructive) {
                data.shops.removeAll()
            }
        }
    }
}

struct AddShopView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddShopView(data: .constant(MultipleShops.sampleData.multipleData), settings: .constant(TickerSettings.sampleSettings))
        }
        .previewInterfaceOrientation(.portrait)
    }
}

