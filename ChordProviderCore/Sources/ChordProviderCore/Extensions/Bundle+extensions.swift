//
//  Bundle+Extensions.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

extension Bundle {

    /// The release version number of the bundle
    public var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    }
    /// The build version number of the bundle
    public var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown Version"
    }
    /// The copyright of the bundle
    public var copyright: String {
        return infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Unknown Copyright"
    }
}
