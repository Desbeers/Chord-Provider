//  MARK: - functions that are specific for iOS

import SwiftUI

extension Color {
    var hexString: String {
        return UIColor(self).hexString
    }
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
