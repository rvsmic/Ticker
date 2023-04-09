//
//  SimpleAddItemsView.swift
//  Ticker
//
//  Created by Michał Rusinek on 01/09/2022.
//

import SwiftUI

struct SimpleAddItemsView: View {
    
    @Binding var data: MultipleItems.MultipleData
    @State private var newItem = ""
    @State private var newAdditionalNote = ""
    @State private var newCount = 1
    @State private var showDeleteAlert = false
    private let theme: TickerColor = .InnerAccentColor
    @Binding var settings: TickerSettings
    
    var body: some View {
        Form {
            Section(header: Text("New Item")) {
                List {
                    TextField("Item name", text: $newItem)
                        .padding(.vertical,5)
                    TextField("Additional note", text: $newAdditionalNote)
                        .padding(.vertical,5)
                    ZStack {
                        ZStack {
                            Capsule()
                                .fill(theme.color)
                            TextField("Count", value: $newCount, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .padding(.vertical,5)
                                .foregroundColor(.black)
                        }
                        .fixedSize()
                        HStack {
                            Text("Count:")
                            Spacer()
                            Stepper("", value: $newCount, in: 1...100)
                                .fixedSize()
                        }
                        .padding(.vertical,5)
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                let item = Item(name: newItem, count: newCount, additionalNote: newAdditionalNote)
                                data.items.append(item)
                                newCount = 1
                                newItem = ""
                                newAdditionalNote = ""
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
                            .tint(.black)
                        }
                        Spacer()
                    }
                    .listRowBackground(newItem.isEmpty ? Color.gray.opacity(0.3) : theme.color)
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
                HStack { Text("Item"); Spacer(); Text("Count") }
            }) {
                    List {
                        ForEach($data.items) { $item in
                            VStack (alignment: .leading){
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(item.count)")
                                }
                                if !item.additionalNote.isEmpty {
                                    Text(item.additionalNote)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical,5)
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    newItem = item.name
                                    newAdditionalNote = item.additionalNote
                                    newCount = item.count
                                    withAnimation {
                                        data.deleteItem(deleteItem: item)
                                    }
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                .tint(theme.color)
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
                    .modifier(ListBackgroundModifier())
                }
                .opacity(data.items.isEmpty ? 0 : 100)
        }
        .alert("Clear all items?", isPresented: $showDeleteAlert) {
            Button("Confirm", role: .destructive) {
                data.items.removeAll()
            }
        }
    }
}

struct SimpleAddItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SimpleAddItemsView(data: .constant(MultipleItems.sampleData.multipleData), settings: .constant(TickerSettings.sampleSettings))
        }
    }
}
