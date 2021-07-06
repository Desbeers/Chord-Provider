// MARK: - class: one line of the song

import Foundation

public class Line: Identifiable {
    public var id = UUID()
    public var parts = [Part]()
    public var measures = [Measure]()
    public var tablature: String?
    public var comment: String?
    public var plain: String?
}
