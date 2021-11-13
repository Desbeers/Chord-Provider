// MARK: - class: a part of a line of the song

import Foundation

public class Part: Identifiable {
    public var id = UUID()
    public var chord: String?
    public var lyric: String?
    
    public var empty: Bool {
        return (chord ?? "").isEmpty && (lyric ?? "").isEmpty
    }
}
