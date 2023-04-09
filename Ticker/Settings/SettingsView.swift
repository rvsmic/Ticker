//
//  SettingsView.swift
//  Ticker
//
//  Created by Michał Rusinek on 02/09/2022.
//

import SwiftUI

struct SettingsView: View {
    
    private let theme: TickerColor = .InnerAccentColor
    @Binding var settings: TickerSettings
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
                List {
                    Section (header: Text("Global Settings")){
                        
                            HStack {
                                Image(systemName: "textformat.abc")
                                    .foregroundColor(theme.color)
                                Toggle("Icon labels", isOn: $settings.iconLabels)
                                    .tint(theme.color)
                            }
                            
                            HStack {
                                Image(systemName: "iphone")
                                    .padding([.leading, .trailing],6)
                                    .foregroundColor(theme.color)
                                Toggle("Gradient start screen", isOn: $settings.alternateStartScreen)
                                    .tint(theme.color)
                            }
                        
                        
                    }
                    Section (header: Text("Contact")) {
                        Link (destination: URL(string: "https://www.instagram.com/rvsmic/")!) {
                            Label("@rvsmic on Instagram", systemImage: "link")
                                .font(.headline)
                                .foregroundColor(theme.color)
                        }
                    }
                }
                .modifier(ListBackgroundModifier())
                .background(.ultraThinMaterial)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Michał Rusinek, VIII 2022")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .background(.ultraThinMaterial)
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(settings: .constant(TickerSettings.sampleSettings), saveAction: {})
        }
    }
}
