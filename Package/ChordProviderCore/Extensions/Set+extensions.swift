//
//  Set+Extensions.swift
//  ChordProviderCore
//
//  © 2026 Nick Berendsen
//

import Foundation

extension Set where Element == Int {

    /// The pitch classes as a 12-bit mask
    ///
    /// - Note: Bit 0 = C, bit 1 = C#, ... bit 11 = B
    public var mask: Int {
        reduce(0) { $0 | (1 << $1) }
    }
}
