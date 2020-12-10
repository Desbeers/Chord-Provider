import Foundation

public class Diagram: Codable {
    public var  frets: [Int]
    public var  fingers: [Int]
    public var  baseFret: Int
    public var  barres: [Int]
    public var  capo: Bool?
    public var  midi: [Int]
    public var  key: String
    public var  suffix: String

    public static var all: [Diagram] {
        print("Diagram.all: loading diagrams")
        guard let data = ChordsData.data else {
            return []
        }
        do {
            let allChords = try JSONDecoder().decode([Diagram].self, from: data)
            return allChords
        } catch {
            print(error)
        }
        return []
    }
}

func GetChordDiagram(song: Song, chord: String, baseFret: String) -> (frets: String, fingers: String) {
    let base:Int = Int(baseFret.prefix(1)) ?? 1
    
    let chordRegex = try! NSRegularExpression(pattern: "([CDEFGABb#]+)(.*)")
    
    var key = ""
    var suffix = ""
    if let match = chordRegex.firstMatch(in: chord, options: [], range: NSRange(location: 0, length: chord.utf16.count)) {
        if let keyRange = Range(match.range(at: 1), in: chord) {
            key = chord[keyRange].trimmingCharacters(in: .newlines)
            /// Dirty, some chords in the database are only in the flat version....
            if key == "G#" {
                key = "Ab"
            }
        }

        if let valueRange = Range(match.range(at: 2), in: chord) {
            switch chord[valueRange] {
                case "":
                    suffix = "major"
                case "m":
                    suffix = "minor"
                case "b":
                    suffix = "flat"
                default:
                    suffix = String(chord[valueRange])
            }
        }
    }
    let match = song.diagram.filter { $0.key == key && $0.suffix == suffix && $0.baseFret == base }
    
    var frets = ""
    var fingers = ""
    
    if !match.isEmpty {
        for item in match.first!.frets {
            frets += (item == -1 ? "x" : String(item + base - 1))
        }
        for item in match.first!.fingers {
            fingers += (item == 0 ? "-" : String(item))
        }
    }
    return (frets,fingers)
    
}
