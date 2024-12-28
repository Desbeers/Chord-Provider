//
//  Bundle+Extensions.swift
//  Chord Provider
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Bundle {

    /// Decode a JSON file from the bundle
    /// - Parameters:
    ///   - type: The decodable type
    ///   - file: The fil to decode
    ///   - dateDecodingStrategy: The optional Date Decoding Strategy
    ///   - keyDecodingStrategy: The optional Key Decoding Strategy
    /// - Returns: The decoded file
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }

    /// Get the JSON data from a file in the bundle
    /// - Parameter file: The JSON file
    /// - Returns: The content of the JSON file
    func json(from file: String) -> String {
        guard let url = self.url(forResource: file, withExtension: "chordsdb") else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? String(contentsOf: url, encoding: .utf8) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        return data
    }
}

extension Bundle {

    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    }
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown Version"
    }
    var copyright: String {
        return infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Unknown Copyright"
    }
}
