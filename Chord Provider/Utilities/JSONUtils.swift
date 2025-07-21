//
//  JSONUtils.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation
import OSLog

/// Utilities to deal with JSON
enum JSONUtils {
    // Just a placeholder
}

extension JSONUtils {

    /// Encode a struct
    /// - Parameter value: The struct
    /// - Returns: A JSON string
    static func encode<T: Codable>(_ value: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let encodedData = try encoder.encode(value)
            let content = String(data: encodedData, encoding: .utf8) ?? "error"
            return content
        } catch {
            Logger.parser.error("\(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    /// Decode JSON
    /// - Parameters:
    ///   - string: The string to decode
    ///   - struct: The Struct to use
    static func decode<T: Codable>(_ string: String, struct: T.Type) throws -> T {
        let decoder = JSONDecoder()
        do {
            let data = Data(string.utf8)
            let content = try decoder.decode(T.self, from: data)
            return content
        } catch DecodingError.keyNotFound(let key, let context) {
            Logger.parser.error("Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
            throw AppError.jsonDecoderError
        } catch DecodingError.typeMismatch(_, let context) {
            Logger.parser.error("Failed to decode due to type mismatch – \(context.debugDescription)")
            throw AppError.jsonDecoderError
        } catch DecodingError.valueNotFound(let type, let context) {
            Logger.parser.error("Failed to decode due to missing \(type) value – \(context.debugDescription)")
            throw AppError.jsonDecoderError
        } catch DecodingError.dataCorrupted(_) {
            Logger.parser.error("Failed to decode because it appears to be invalid JSON")
            throw AppError.jsonDecoderError
        } catch {
            Logger.parser.error("Failed to decode: \(error.localizedDescription)")
            throw AppError.jsonDecoderError
        }
    }
}
