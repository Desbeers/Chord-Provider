import SwiftUI

// App AppDelegate for macOS

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"
    private let kAppleInterfaceStyle = "AppleInterfaceStyle"
    private let kAppleInterfaceStyleSwitchesAutomatically = "AppleInterfaceStyleSwitchesAutomatically"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /// Get the appearance of the application
        var isLight: Bool { NSApp.effectiveAppearance.name == NSAppearance.Name.aqua }
        /// And save it; its for the html colors
        UserDefaults.standard.set(isLight ? "Light" : "Dark", forKey: "appTheme")
        /// Switch to dark mode when going full screen
        NotificationCenter.default.addObserver(
            forName: NSWindow.willEnterFullScreenNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { note in
                NSApp.appearance = NSAppearance(named: .darkAqua)
                UserDefaults.standard.set("Dark", forKey: "appTheme")
                print("Entered Fullscreen")
        })
        /// Go back to default when exiting full screen
        NotificationCenter.default.addObserver(
            forName: NSWindow.willExitFullScreenNotification,
            object: nil,
            queue: OperationQueue.main,
            using: { note in
                NSApp.appearance = nil
                UserDefaults.standard.set(isLight ? "Light" : "Dark", forKey: "appTheme")
                print("Exited Fullscreen")
        })
        /// Act on change of appearance, again for the html colors
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(self.appleInterfaceThemeChangedNotification(notification:)),
            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
            object: nil
        )
    }
    /// Set the change of appearance
    @objc func appleInterfaceThemeChangedNotification(notification: Notification) {
        if let appleInterfaceStyle = UserDefaults.standard.object(forKey: self.kAppleInterfaceStyle) as? String {
            UserDefaults.standard.set(appleInterfaceStyle, forKey: "appTheme")
        } else {
            UserDefaults.standard.set("Light", forKey: "appTheme")
        }
    }
}




func GetAccentColor() -> String {
    return NSColor.controlAccentColor.hexString
}

func GetHighlightColor() -> String {
    return NSColor.controlAccentColor.hexString + "53"
}

func GetTextColor() -> String {
    let theme = UserDefaults.standard.object(forKey: "appTheme") as? String ?? "Light"
    return (theme == "Light" ? "#000000" : "#ffffff")
}

func GetSystemBackground() -> String {
    return NSColor.textBackgroundColor.hexString
}

extension NSColor {
    var hexString: String{
        let rgbColor = usingColorSpace(.extendedSRGB) ?? NSColor(red: 1, green: 1, blue: 1, alpha: 1)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}

struct FancyBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    return NSVisualEffectView()
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}
