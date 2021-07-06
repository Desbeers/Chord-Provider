// MARK: - class: sections of the song

import Foundation

public class Sections: Identifiable {
    public var id = UUID()
    public var name: String?
    public var type: String?
    public var lines = [Line]()
}
