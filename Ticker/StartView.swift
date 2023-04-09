//
//  StartView.swift
//  Ticker
//
//  Created by Michał Rusinek on 28/08/2022.
//

import SwiftUI
import SpriteKit

struct StartView: View {
    
    @Binding var items: [Item]
    @Binding var shops: [Shop]
    @Binding var settings: TickerSettings
    
    let itemsSaveAction: ()->Void
    let shopsSaveAction: ()->Void
    let settingsSaveAction: ()->Void
    
    @Environment(\.scenePhase) private var scenePhase
    
    private let color: TickerColor = .InnerAccentColor
    
    var body: some View {
        ZStack {
            ZStack {
                color.color
                    .ignoresSafeArea()
                LinearGradient(colors: [Color(UIColor.systemBackground).opacity(0.5), color.color], startPoint: .top, endPoint: .bottom)
                    .opacity(!settings.alternateStartScreen ? 0 : 1)
                    .ignoresSafeArea()
                Color.black.opacity(UIViewController().isDarkMode ? 0.5 : 0)
                    .ignoresSafeArea()
                Image("TickerBackground")
                    .opacity(settings.alternateStartScreen ? 0 : 0.1)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                
            }
            //.offset(x: 0, y: -80)
            
            VStack {
                ZStack {
                    Image("TickerTextLogo")
                        .scaledToFit()
                        .offset(x: 0, y: 80)
                        .opacity(UIViewController().isDarkMode ? 0 : 1)
                    
                    Image("TickerTextLogo")
                        .scaledToFit()
                        .offset(x: 0, y: 80)
                        .colorInvert()
                        .opacity(!UIViewController().isDarkMode ? 0 : 1)
                }
                Spacer()
                HStack {
                    ZStack {
                        Capsule()
                            .fill(.thinMaterial)
                        NavigationLink(destination: ItemsView(items: $items, saveAction: itemsSaveAction, settings: $settings)) {
                            Label("Simple mode", systemImage: "chevron.right")
                                .padding([.bottom,.top])
                                .font(.headline)
                        }
                    }
                    Spacer()
                    ZStack {
                        Capsule()
                            .fill(.thinMaterial)
                        NavigationLink(destination: ShopsView(shops: $shops, saveAction: shopsSaveAction, settings: $settings)) {
                            Label("Shops mode", systemImage: "chevron.right")
                                .padding([.bottom,.top])
                                .font(.headline)
                        }
                    }
                }
                .scaledToFit()
                .padding(.bottom,80)
                .foregroundColor(.primary)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem (placement: .confirmationAction){
                NavigationLink(destination: SettingsView(settings: $settings, saveAction: settingsSaveAction)) {
                    VStack {
                        Image(systemName: "gearshape")
                        if settings.iconLabels {
                            Text("Settings")
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .tint(.black)
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                itemsSaveAction()
                shopsSaveAction()
                settingsSaveAction()
            }
        }
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UIViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                StartView(items: .constant(Item.sampleData), shops: .constant(Shop.sampleData), settings: .constant(TickerSettings.previewSettings), itemsSaveAction: {}, shopsSaveAction: {}, settingsSaveAction: {})
            }
            NavigationView {
                StartView(items: .constant(Item.sampleData), shops: .constant(Shop.sampleData), settings: .constant(TickerSettings.previewSettings), itemsSaveAction: {}, shopsSaveAction: {}, settingsSaveAction: {})
            }
            .preferredColorScheme(.dark)
        }
    }
}
