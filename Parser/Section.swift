import Foundation

public class Section: Identifiable {
    public var id = UUID()
    public var name: String?
    public var type: String?
    public var lines = [Line]()
}
