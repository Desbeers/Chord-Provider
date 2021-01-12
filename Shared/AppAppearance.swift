//  MARK: - class: App Appearance for macOS and iOS

/// This optional overrules the appearance of the application

import SwiftUI

//  MARK: - ViewModifier: observe the appearance selector

struct AppAppearanceModifier: ViewModifier {
    
    @AppStorage("appAppearance") var appAppearance: AppAppearance.displayMode = .system
    @AppStorage("appColor") var appColor: AppAppearance.displayMode = .light
    @Environment(\.colorScheme) var colorScheme
    
    @State var preferredColorScheme: ColorScheme? = nil

    func body(content: Content) -> some View {
        content
        .onAppear(
            perform: {
                OverrideAppearance()
                GetColorMode()
            }
        )
        .onChange(of: appAppearance) { appearance in
            OverrideAppearance()
        }
        .onChange(of: colorScheme) {color in
            GetColorMode()
        }
    }
    func OverrideAppearance() {
        #if os(macOS)
        switch appAppearance {
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
        switch appAppearance {
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
    func GetColorMode() {
        if appAppearance == .system {
        #if os(macOS)
            let isLight: String = UserDefaults.standard.object(forKey: "AppleInterfaceStyle") as? String ?? "Light"
            appColor = (isLight == "Light" ? .light : .dark)
        #endif
        #if os(iOS)
            let appleInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            switch appleInterfaceStyle.rawValue {
                case 1:
                    appColor = .light
                case 2:
                    appColor = .dark
                default:
                    print("Unknown")
            }
        #endif
        }
        else {
            appColor = appAppearance
        }
        //UserDefaults.standard.set(appColor.rawValue, forKey: "appColor")
        print(appColor)
    }
}

//  MARK: - View: The picker

/// Different pickers for macOS and iOS.
/// I like the mac style the most but its buggy on iOS.

struct AppAppearanceSwitch: View {
    
    @AppStorage("appAppearance") var appAppearance: AppAppearance.displayMode = .system

    var body: some View {
        Picker(selection: $appAppearance, label: Text("Appearance")) {
            Image(systemName: "circle.lefthalf.fill").tag(AppAppearance.displayMode.system)
            Image(systemName: "sun.max").tag(AppAppearance.displayMode.light)
            Image(systemName: "moon").tag(AppAppearance.displayMode.dark)
        }
        .pickerStyle(SegmentedPickerStyle())
        .labelsHidden()
    }
}

//  MARK: - class: App Appearance

public class AppAppearance {
    enum displayMode: Int {
        case system = 0
        case dark = 1
        case light = 2
    }
    static func GetCurrentColorMode() -> displayMode {
        let value = UserDefaults.standard.object(forKey: "appColor") as? Int ?? 0
        return displayMode(rawValue: value) ?? .light
    }
}



//  MARK: - functions to get system colors for the html view

func GetCommentBackground() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#DDDDDD" : "#666666")
}

func GetAccentColor() -> String {
    /// macOS has variable accent colors; iOS does not; the appliciation decide.
    /// However; if you change the accent color in macOS; the view is not updated.
    /// There is no sane way to detect changes of that setting...
    #if os(macOS)
    return Color.accentColor.hexString
    #endif
    #if os(iOS)
    return Color("AccentColor").hexString
    #endif
}

func GetChordColor() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#000000" : "#ffffff")
}

func GetHighlightColor() -> String {
    return GetAccentColor() + "53"
}

func GetSectionColor() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#666666" : "#AAAAAA")
}

func GetSystemBackground() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#FFFFFF" : "#000000")
}
