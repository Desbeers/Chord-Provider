import Foundation

public class Song: Identifiable {
    public var id = UUID()
    public var title: String?
    public var artist: String?
    public var capo: String?
    public var key: String?
    public var tempo: String?
    public var year: String?
    public var album: String?
    public var tuning: String?
    public var html: String?
    public var htmlchords: String?
    public var musicpath: String?
    public var diagram = [Diagram]()
    public var custom = [String: String]()
    public var sections = [Section]()
    public var chords = [String: String]()
}
