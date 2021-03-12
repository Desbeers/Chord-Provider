//  MARK: - struct: the chords in the song

import Foundation
import GuitarChords

public struct Chord: Identifiable {
    public var id = UUID()
    public var name: String
    public var key: GuitarChords.Key
    public var suffix: GuitarChords.Suffix
    public var define: String
    public var basefret: Int {
        return Int(define.prefix(1)) ?? 1
    }
}
