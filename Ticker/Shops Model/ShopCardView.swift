//
//  ShopCardView.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

struct ShopCardView: View {
    @Binding var shop: Shop
    @Binding var settings: TickerSettings
    
    var body: some View {
        VStack (alignment: .leading){
            Text(shop.name.name)
                .font(.title2.bold())
            HStack {
                Spacer()
                ZStack {
                    Capsule()
                        .fill(shop.color.accentColor)
                    
                    HStack {
                        VStack {
                            Label("\(shop.boughtCount())", systemImage: "cart.fill")
                                .font(.footnote.bold())
                            if settings.iconLabels {
                                Text("Bought")
                                    .font(.caption2)
                                    .padding([.leading,.trailing])
                            }
                        }
                        Spacer()
                        VStack {
                            Label("\(shop.items.count - shop.boughtCount())", systemImage: "cart")
                                .font(.footnote.bold())
                            if settings.iconLabels {
                                Text("To buy")
                                    .font(.caption2)
                                    .padding([.leading,.trailing])
                            }
                        }
                    }
                    .foregroundColor(shop.color.accentContrastColor)
                    .padding(5)
                    .padding(.trailing, 5)
                }
                .fixedSize()
                
            }
            .font(.caption)
        }
        .foregroundColor(shop.color.mainContrastColor)
        .padding()
    }
}

struct ShopCardView_Previews: PreviewProvider {
    static var shop = Shop.sampleData[0]
    static var previews: some View {
        ShopCardView(shop: .constant(shop), settings: .constant(TickerSettings.sampleSettings))
            .background(shop.color.mainColor)
    }
}

