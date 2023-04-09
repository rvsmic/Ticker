//
//  ItemsView.swift
//  Ticker
//
//  Created by Michał Rusinek on 29/08/2022.
//

import SwiftUI

struct ItemsView: View {
    
    @Binding var items: [Item]
    @State private var data = MultipleItems.MultipleData()
    
    let theme: TickerColor = .InnerAccentColor
    @State private var addItemsSheetShown = false
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    @Binding var settings: TickerSettings
    
    init(items: Binding<[Item]>, saveAction: @escaping ()->Void, settings: Binding<TickerSettings>){
        UITableView.appearance().backgroundColor = UIColor(Color.clear)
        self._items = items
        self.saveAction = saveAction
        self._settings = settings
    }
    
    var body: some View {
        VStack {
            if items.count == 0 {
                VStack {
                    Text("Nothing to buy :)")
                        .font(.headline)
                        .foregroundColor(theme.color)
                        .offset(x: 0, y: 80)
                    Spacer()
                }
            }
            else {
                HStack {
                    Spacer()
                    VStack {
                        Text("\(Item.countBought(items: items)) / \(items.count) items")
                            .font(.subheadline)
                        if settings.iconLabels {
                            Text("Count")
                                .font(.caption2)
                        }
                    }
                    .padding(.trailing)
                }
                .foregroundColor(theme.color)
                List {
                    ForEach($items) { $item in
                        HStack {
                            VStack(alignment: .leading) {
                                    Text(item.name)
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
                            .foregroundColor(item.isBought ? theme.color : .primary)
                        }
                        .padding(.vertical,5)
                    }
                }
                .modifier(ListBackgroundModifier())
                .background(
                    Circle().fill(theme.color)
                        .frame(width: 1, height: 1, alignment: .top)
                        .opacity(items.count == Item.countBought(items: items) && items.count != 0 ? 100 : 0)
                        .scaleEffect(items.count == Item.countBought(items: items) && items.count != 0 ? 2000 : 1)
                        .offset(x: 0, y: -(UIScreen.screenHeight)*(1/4))
                        .animation(.easeInOut(duration: 0.5), value: items.count == Item.countBought(items: items) && items.count != 0)
                )
                .clipped()
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            }
        }
        .toolbar {
            ToolbarItem (placement: .confirmationAction){
                Button(action: {
                    addItemsSheetShown = true
                    let multipleItems = MultipleItems(items: items)
                    data = multipleItems.multipleData
                }){
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
                SimpleAddItemsView(data: $data, settings: $settings)
                    .navigationTitle("Edit items")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Discard") {
                                addItemsSheetShown = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Update",action: {
                                addItemsSheetShown = false
                                var multipleItems = MultipleItems(items: items)
                                multipleItems.update(from: data)
                                items = multipleItems.unwrap()
                                items = items.sorted()
                            })
                        }
                    }
            }
        }
        .tint(.primary)
        .navigationTitle("Simple List")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive { saveAction() }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemsView(items: .constant(Item.sampleData), saveAction: {}, settings: .constant(TickerSettings.sampleSettings))
        }
    }
}
