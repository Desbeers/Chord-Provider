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
    /// - Note: Based on code from https://github.com/hacknicity/SmartSearchExample
    struct Matcher {

        /// Creates a new instance for testing matches against `query`.
        init(query: String) {
            // Split `query` into tokens by whitespace and sort them by decreasing length
            searchTokens = query
                .split { $0.isWhitespace }
                .sorted { $0.count > $1.count }
        }
        /// Check if `candidateString` matches `searchString`.
        func matches(_ candidateString: String) -> Bool {
            // If there are no search tokens, everything matches
            guard !searchTokens.isEmpty else {
                return true
            }
            // Split `candidateString` into tokens by whitespaces and chords
            let regex = /(\[[^\]]+\]|[^\s]+)/
            var candidateStringTokens = candidateString.matches(of: regex).map(\.0)
            // Iterate over each search token
            for searchToken in searchTokens {
                // We haven't matched this search token yet
                var matchedSearchToken = false
                // Iterate over each candidate string token
                for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                    // Does `candidateStringToken` start with `searchToken`?
                    if
                        let range = candidateStringToken
                            .range(
                                of: searchToken,
                                options: [.caseInsensitive, .diacriticInsensitive]
                            ),
                        range.lowerBound == candidateStringToken
                            .startIndex {
                        matchedSearchToken = true
                        // Remove the candidateStringToken so we don't match it again against a different searchToken.
                        candidateStringTokens.remove(at: candidateStringTokenIndex)
                        // Check the next search string token
                        break
                    }
                }
                // If we failed to match `searchToken` against the candidate string tokens, there is no match
                guard matchedSearchToken else {
                    return false
                }
            }
            // If we match every `searchToken` against the candidate string tokens, `candidateString` is a match
            return true
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
