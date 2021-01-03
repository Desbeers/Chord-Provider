import SwiftUI

func GetAccentColor() -> String {
    return NSColor.controlAccentColor.hexString
}

func GetHighlightColor() -> String {
    return NSColor.controlAccentColor.hexString + "53"
}

func GetTextColor() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#000000" : "#ffffff")
}

func GetSystemBackground() -> String {
    return NSColor.textBackgroundColor.hexString
}

func GetCommentBackground() -> String {
    return NSColor.systemGray.hexString + "26"
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
