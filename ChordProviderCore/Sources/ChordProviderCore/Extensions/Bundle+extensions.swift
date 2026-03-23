//
//  Bundle+Extensions.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
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
    ) throws -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            throw ChordProviderError.jsonDecoderError(error: "Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            throw ChordProviderError.jsonDecoderError(error: "Failed to load \(file) from bundle.")
        }
        do {
            return try JSONUtils.decode(data, struct: T.self)
        } catch {
            throw error
        }

    }
}

extension Bundle {

    /// The release version number of the bundle
    public var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Version"
    }
    /// The build version number of the bundle
    public var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown Version"
    }
    /// The copyright of the bundle
    public var copyright: String {
        return infoDictionary?["NSHumanReadableCopyright"] as? String ?? "Unknown Copyright"
    }
}
