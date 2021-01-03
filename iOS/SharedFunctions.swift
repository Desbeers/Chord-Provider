import SwiftUI

func GetAccentColor() -> String {
    return UIColor.systemPurple.hexString
}

func GetHighlightColor() -> String {
    return UIColor.systemPurple.hexString + "53"
}

func GetTextColor() -> String {
    let theme = AppAppearance.GetCurrentColorMode()
    return (theme == .light ? "#000000" : "#ffffff")
}

func GetSystemBackground() -> String {
    return UIColor.systemBackground.hexString
}
func GetCommentBackground() -> String {
    return UIColor.systemGray.hexString + "26"
}

extension UIColor {
    var hexString: String{
        let rgbColor = self
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        rgbColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb:Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return String(format: "#%06x", rgb)
    }
}
