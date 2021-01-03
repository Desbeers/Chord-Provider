//
//  AppAppearance.swift
//  Chord Provider
//
//  Created by Nick Berendsen on 02/01/2021.
//

import SwiftUI

public class AppAppearance {

    static func GetCurrentDisplayMode() -> displayMode {
        let value = UserDefaults.standard.object(forKey: "appAppearance") as? Int ?? 0
        return displayMode(rawValue: value) ?? .system
    }

    static func GetCurrentColorMode() -> displayMode {
        let value = UserDefaults.standard.object(forKey: "appColor") as? Int ?? 0
        return displayMode(rawValue: value) ?? .light
    }
    
    enum displayMode: Int {
        case system = 0
        case dark = 1
        case light = 2
    }

    static func SetAppearance() {
        var appearance: displayMode = .light
        #if os(macOS)
            let isLight: String = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as? String ?? "Light"
            appearance = (isLight == "Light" ? .light : .dark)
        #endif
        #if os(iOS)
            let appleInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            switch appleInterfaceStyle.rawValue {
                case 1:
                    appearance = .light
                case 2:
                    appearance = .dark
                default:
                    print("Unknown")
            }
        #endif
        UserDefaults.standard.set((appearance.rawValue), forKey: "systemAppearance")
        
        switch GetCurrentDisplayMode() {
        case .system:
            UserDefaults.standard.set((appearance.rawValue), forKey: "appColor")
        case .dark:
            UserDefaults.standard.set(displayMode.dark.rawValue, forKey: "appColor")
        case .light:
            UserDefaults.standard.set(displayMode.light.rawValue, forKey: "appColor")
        }
    }

    static func OverrideAppearance() {
        /// This function is smart; it will only change the appearance.
        /// Then, in MainView a change of @Environment(\.colorScheme) will be triggered
        /// and calls the SetAppearance() fuction.
        let displayMode = GetCurrentDisplayMode()
        #if os(macOS)
        switch displayMode {
            case .dark:
                NSApp.appearance = NSAppearance(named: .darkAqua)
            case .light:
                NSApp.appearance = NSAppearance(named: .aqua)
            case .system:
                NSApp.appearance = nil
        }
        #endif
        #if os(iOS)
        var userInterfaceStyle: UIUserInterfaceStyle
        switch displayMode {
            case .dark:
                userInterfaceStyle = .dark
            case .light:
                userInterfaceStyle = .light
            case .system:
                userInterfaceStyle = .unspecified
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
        #endif
    }
}

struct AppAppearanceModifier: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .onAppear(
                perform: {
                    AppAppearance.OverrideAppearance()
                }
            )
            .onChange(of: colorScheme) {color in
                print("New colorscheme!")
                AppAppearance.SetAppearance()
            }
    }
}

struct AppAppearanceSwitch: View {
    
    @AppStorage("appAppearance") var appAppearance: AppAppearance.displayMode = .system

    var body: some View {

        Picker(selection: $appAppearance, label: Text("Color")) {
            Text("Light").tag(AppAppearance.displayMode.light)
            Text("Dark").tag(AppAppearance.displayMode.dark)
            Text("System").tag(AppAppearance.displayMode.system)
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: appAppearance) { newValue in
            AppAppearance.OverrideAppearance()
        }
    }
}
