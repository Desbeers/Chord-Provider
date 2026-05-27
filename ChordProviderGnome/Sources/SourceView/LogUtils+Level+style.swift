//
//  LogUtils+Level+style.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import ChordProviderCore

extension LogUtils.Level {

    var style: (color: String, icon: String) {
        switch self {            
        case .info:
            ("#ffffff", "dialog-information-symbolic")
        case .notice:
            ("#1a5fb4", "view-reveal-symbolic")
        case .warning:
            ("#e5a50a", "dialog-warning-symbolic")
        case .error:
            ("#e01b24", "dialog-error-symbolic")
        }
    }
}