//
//  AddItemsView.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import SwiftUI

struct AddItemsView: View {
    
    @Binding var data: Shop.Data
    
    @State private var newItem = ""
    @State private var itemCount = 1
    @State private var additionalNote = ""
    @State private var showDeleteAlert = false
    @Binding var settings: TickerSettings
    
    var body: some View {
        Form {
            Section(header: Text("New Item")) {
                List {
                    TextField("Item name", text: $newItem)
                        .padding(.vertical,5)
                    TextField("Additional note", text: $additionalNote)
                        .padding(.vertical,5)
                    ZStack {
                        ZStack {
                            Capsule()
                                .fill(data.color.mainColor)
                            TextField("Count", value: $itemCount, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.vertical,5)
                                .foregroundColor(data.color.mainContrastColor)
                        }
                        .fixedSize()
                        HStack {
                            Text("Count:")
                            Spacer()
                            Stepper("", value: $itemCount, in: 1...100)
                                .fixedSize()
                        }
                        .padding(.vertical,5)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                let item = Item(name: newItem, count: itemCount, additionalNote: additionalNote)
                                data.items.append(item)
                                itemCount = 1
                                newItem = ""
                                additionalNote = ""
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
                            .tint(data.color.mainContrastColor)
                        }
                        Spacer()
                    }
                    .listRowBackground(newItem.isEmpty ? Color.gray.opacity(0.3) : data.color.mainColor)
                    .disabled(newItem.isEmpty)
                }
            }
            Section(header: ZStack {
                Button(action: {
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
                }
                HStack {Text("Item");Spacer();Text("Count")}
            }) {
                List {
                    ForEach(data.items) { item in
                        HStack {
                            VStack (alignment: .leading){
                                
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
                        }
                        .padding(.vertical,5)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                newItem = item.name
                                additionalNote = item.additionalNote
                                itemCount = item.count
                                withAnimation {
                                    data.deleteItem(deleteItem: item)
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .foregroundColor(data.color.mainContrastColor)
                                    .font(.headline)
                            }
                            .tint(data.color.mainColor)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    data.deleteItem(deleteItem: item)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .opacity(data.items.isEmpty ? 0 : 100)
        }
        .alert("Clear all items?", isPresented: $showDeleteAlert) {
            Button("Confirm", role: .destructive) {
                withAnimation {
                    data.items.removeAll()
                }
            }
        }
    }
}

struct AddItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemsView(data: .constant(Shop.sampleData[0].data), settings: .constant(TickerSettings.sampleSettings))
    }
}

