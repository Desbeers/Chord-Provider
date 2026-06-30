// Simple script to generate Swift snippets for the documentation

import Foundation
import ChordProviderCore

@main
struct Generate {
    /// The main function
    static func main() {
        let directives = ChordPro.Directive.allCases
            .filter { !ChordPro.Directive.customDirectives.contains($0) }

        // MARK: Supported directives

        saveSnippet(
            directives: directives.filter { !ChordPro.Directive.unsupportedDirectives.contains($0) },
            fileName: "supported-directives.swift"
        )

        // MARK: Unsupported directives

        saveSnippet(
            directives: directives.filter { ChordPro.Directive.unsupportedDirectives.contains($0) },
            fileName: "unsupported-directives.swift"
        )
    }

    static let baseURL = URL(
        fileURLWithPath:"\(FileManager.default.currentDirectoryPath)/Resources/GenerateDocs/Documentation.docc/Code/Generated/"
    )

    static func saveSnippet(
        directives: [ChordPro.Directive],
        fileName: String
    ) {
        let url = baseURL
            .appendingPathComponent(fileName)
        let groups = Dictionary(grouping: directives, by: \.details.lineType)
        var output: [String] = []
        for (lineType, directives) in groups.sorted(using: KeyPathComparator(\.key)) {
            output.append("\n\(lineType.display.uppercased())\n")
            for directive in directives.sorted() {
                output += [
                    "\(directive.source.long):",
                    "  - \(directive.details.help)"
                ]
            }
        }
        do {
            try output.joined(separator: "\n").write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}
