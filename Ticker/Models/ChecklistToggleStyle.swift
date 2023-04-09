//
//  ChecklistToggleStyle.swift
//  Ticker
//
//  Created by Michał Rusinek on 28/09/2022.
//

import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 24, height: 24)
                //.foregroundColor(configuration.isOn ? .purple : .gray)
                .font(.headline)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct TestView: View {
    @State private var checked = false
    var body: some View {
        HStack {
            Toggle("INFO", isOn: $checked)
            .toggleStyle(.checklist)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
extension ToggleStyle where Self == ChecklistToggleStyle {
    static var checklist: ChecklistToggleStyle { .init() }
}
