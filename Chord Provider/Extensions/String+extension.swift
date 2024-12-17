//
//  String+extension.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension String: @retroactive Identifiable {

    /// Make a String identifiable
    public var id: Int {
        hash
    }
}
