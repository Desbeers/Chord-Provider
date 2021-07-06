// MARK: - class: the song

import Foundation

public class Song: Identifiable, ObservableObject {
    public var id = UUID()
    public var title: String?
    public var artist: String?
    public var capo: String?
    public var key: String?
    public var tempo: String?
    public var time: String?
    public var year: String?
    public var album: String?
    public var tuning: String?
    public var html: String?
    public var path: URL?
    public var musicpath: URL?
    public var sections = [Sections]()
    public var chords = [Chord]()
}
