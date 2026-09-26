//
//  Search.swift
//  ChordProviderGnome
//
//  © 2026 Nick Berendsen
//

import Foundation
import ChordProviderCore

/// Search related items
enum Search {
    // Just a namespace
}

extension Search {

    /// A struct for searching the library a bit smart
    struct Matcher {

        /// Creates a new instance for testing matches against `query`.
        init(query: String) {
            // Split `query` into tokens by whitespace
            searchTokens = query.split { $0.isWhitespace }
        }
        /// Check if `candidateString` matches `searchString`.
        func matches(_ candidateString: String) -> Bool {
            guard !searchTokens.isEmpty else {
                return true
            }
            /// Regex to split a line into tokens by whitespaces and chordswhtespaces and chords
            let regex = /(\[[^\]]+\]|[^\s]+)/

            for line in candidateString.components(separatedBy: .newlines) {
                let candidateStringTokens = line.matches(of: regex).map(\.0)
                var candidateStringTokenIndex = 0
                var matchedSearchTokens = 0

                for searchToken in searchTokens {
                    var matched = false
                    while candidateStringTokenIndex < candidateStringTokens.count {
                        let candidateStringToken = candidateStringTokens[candidateStringTokenIndex]
                        candidateStringTokenIndex += 1
                        if
                            let range = candidateStringToken.range(
                                of: searchToken,
                                options: [.caseInsensitive, .diacriticInsensitive]
                            ),
                            range.lowerBound == candidateStringToken.startIndex {
                            matched = true
                            matchedSearchTokens += 1
                            break
                        }
                    }
                    if !matched {
                        break
                    }
                }
                if matchedSearchTokens == searchTokens.count {
                    return true
                }
            }
            return false
        }
        /// The tokens to search for
        private(set) var searchTokens: [String.SubSequence]
    }
}

extension Array where Element == Song {

    /// Search an array of ``Song`` by the a query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Song``
    public func search(_ query: String) -> [Song] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { songs in
            searchMatcher.matches(songs.content)
        }
    }
}
