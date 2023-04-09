//
//  ShopDetailView.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

struct ShopDetailView: View {
    
    @State private var data = Shop.Data()
    
    @Binding var shop: Shop
    @State private var addItemsSheetShown = false
    @Binding var settings: TickerSettings
    
    init(shop: Binding<Shop>, settings: Binding<TickerSettings>){
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._shop = shop
        self._settings = settings
    }
    
    var body: some View {
        VStack {
            if shop.items.count == 0 {
                VStack {
                    Text("Nothing to buy :)")
                        .font(.headline)
                        .foregroundColor(shop.color.mainColor)
                        .offset(x: 0, y: 80)
                    Spacer()
                }
            }
            else {
                HStack {
                    Spacer()
                    VStack {
                        Text("\(shop.boughtCount()) / \(shop.items.count) items")
                            .font(.subheadline)
                        if settings.iconLabels {
                            Text("Count")
                                .font(.caption2)
                        }
                    }
                }
                .padding(.trailing)
                .foregroundColor(shop.color.mainColor)
                List {
                    ForEach($shop.items) { $item in
                        HStack {
                            VStack (alignment: .leading) {
                                Text("\(item.name)")
                                    .font(.headline)
                                if !item.additionalNote.isEmpty {
                                    Text("\(item.additionalNote)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Spacer()
                            Text("\(item.count)")
                            Toggle("", isOn: $item.isBought)
                            .toggleStyle(.checklist)
                            .foregroundColor(item.isBought ? shop.color.mainColor : .primary)
                        }
                        .padding(.vertical,5)
                    }
                }
                .modifier(ListBackgroundModifier())
                .background(
                    Circle().fill(shop.color.mainColor)
                        .frame(width: 1, height: 1, alignment: .top)
                        .opacity(shop.items.count == shop.boughtCount() && shop.items.count != 0 ? 100 : 0)
                        .scaleEffect(shop.items.count == shop.boughtCount() && shop.items.count != 0 ? 2000 : 1)
                        .offset(x: 0, y: -(UIScreen.screenHeight)*(1/4))
                        .animation(.easeInOut(duration: 0.5), value: shop.items.count == shop.boughtCount() && shop.items.count != 0)
                )
                .clipped()
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            }
        }
        .navigationTitle(shop.name.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    addItemsSheetShown = true
                    data = shop.data
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
        .sheet(isPresented: $addItemsSheetShown) {
            NavigationView {
                AddItemsView(data: $data, settings: $settings)
                    .navigationTitle(shop.name.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                addItemsSheetShown = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update") {
                                addItemsSheetShown = false
                                shop.update(from: data)
                                shop.items = shop.items.sorted()
                            }
                        }
                    }
            }
        }
        .tint(.primary)
    }
}

struct ShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopDetailView(shop: .constant(Shop.sampleData[0]), settings: .constant(TickerSettings.sampleSettings))
        }
    }
}

