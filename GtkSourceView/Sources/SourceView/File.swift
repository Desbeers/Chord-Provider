//
//  File.swift
//  GtkSourceView
//
//  Created by Nick Berendsen on 03/01/2026.
//

import Foundation
import ChordProviderCore


public struct DirectiveWrapper: Identifiable {
    public init(id: String, directive: ChordPro.Directive) {
        self.id = id
        self.directive = directive
    }
    
    public let id: String
    public let directive: ChordPro.Directive
}
