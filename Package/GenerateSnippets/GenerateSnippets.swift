// Simple script to generate Swift snippets for the documentation

import Foundation
import ChordProviderCore

// swiftlint:disable one_declaration_per_file
// swiftlint:disable convenience_type

/// Generate snippets for editor and documantation.
///
/// - Note: This is only needed when ChordPro directives are added or modified.
@main
struct Generate {

    /// The main function
    static func main() {
        EditorSnippets.main()
        DocSnippets.main()
    }
}

// swiftlint:enable convenience_type

// swiftlint:disable indentation_width

/// Generate snippets for the editor
enum EditorSnippets {

    /// The main function
    static func main() {
        var path = FileManager.default.currentDirectoryPath
        path += "/Package/ChordProviderEditor/ChordProviderEditor/Resources/chordpro.snippets"
        var output = """
<?xml version="1.0" encoding="UTF-8"?>
<snippets _group="ChordPro">

"""
        let directives = ChordPro.Directive.allCases
        for directive in directives where !ChordPro.Directive.unsupportedDirectives.contains(directive) {
            var text = "\(directive.source.long)"
            if ChordPro.Directive.withPlainArgument.contains(directive) {
                text += ": ${1:\(directive.details.defaultValue ?? directive.details.label)}"
            }
            output += """
    <snippet _name="\(directive.details.label)" trigger="{\(directive.source.long)}" _description="\(directive.details.help)">
        <text languages="chordpro">\(text)}</text>
    </snippet>

"""
        }

        output += """
</snippets>

"""
        do {
            if let url = URL(string: path) {
                try output.write(to: url, atomically: true, encoding: .utf8)
            }
        } catch {
            print(error)
        }
    }
}

// swiftlint:enable indentation_width

/// Generate snippets for the documentation
enum DocSnippets {

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

    /// The base URL
    static let baseURL = URL(
        fileURLWithPath: "\(FileManager.default.currentDirectoryPath)/Package/ChordProviderDocs/Documentation.docc/Code/Generated/"
    )

    /// Save the snippets
    static func saveSnippet(
        directives: [ChordPro.Directive],
        fileName: String
    ) {
        let url = baseURL
            .appendingPathComponent(fileName)
        let groups = Dictionary(grouping: directives, by: \.details.lineType)
        var output: [String] = []
        for (lineType, allDirectives) in groups.sorted(using: KeyPathComparator(\.key)) {
            output.append("\n\(lineType.display.uppercased())\n")
            for directive in allDirectives.sorted() {
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

// swiftlint:enable one_declaration_per_file
