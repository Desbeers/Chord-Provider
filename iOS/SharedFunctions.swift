//  MARK: - functions that are specific for iOS

import SwiftUI

extension Color {
    var hexString: String {
        let uiColor: UIColor
        
        if self.description.contains("NamedColor") {
            let lowerBound = self.description.range(of: "name: \"")!.upperBound
            let upperBound = self.description.range(of: "\", bundle")!.lowerBound
            let assetsName = String(self.description[lowerBound..<upperBound])
            
            uiColor = UIColor(named: assetsName)!
        } else {
            uiColor = UIColor(self)
        }
        return uiColor.hexString
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
