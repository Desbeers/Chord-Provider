//
//  JSONUtils.swift
//  ChordProviderCore
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Utilities to deal with JSON
public enum JSONUtils {
    // Just a placeholder
}

extension JSONUtils {

    /// Encode a struct
    /// - Parameter value: The struct
    /// - Returns: A JSON string
    public static func encode<T: Codable>(_ value: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let encodedData = try encoder.encode(value)
            let content = String(data: encodedData, encoding: .utf8) ?? "error"
            return content
        } catch {
            LogUtils.shared.setLog(
                level: .error,
                category: .jsonParser,
                message: error.localizedDescription
            )
            throw error
        }
    }

    /// Decode JSON
    /// - Parameters:
    ///   - data: The data to decode
    ///   - struct: The Struct to use
    public static func decode<T: Decodable>(_ data: Data, struct: T.Type) throws(ChordProviderError) -> T {
        let decoder = JSONDecoder()
        do {
            let content = try decoder.decode(T.self, from: data)
            return content
        } catch DecodingError.keyNotFound(let key, let context) {
            throw .jsonDecoderError(
                error: "Failed to decode due to missing key '\(key.stringValue)' not found",
                context: "\(context.debugDescription)"
            )
        } catch DecodingError.typeMismatch(_, let context) {
            throw .jsonDecoderError(
                error: "Failed to decode due to type mismatch",
                context: "\(context.debugDescription)"
            )
        } catch DecodingError.valueNotFound(let type, let context) {
            throw .jsonDecoderError(
                error: "Failed to decode due to missing \(type) value", 
                context: "\(context.debugDescription)"
            )
        } catch DecodingError.dataCorrupted(_) {
            throw .jsonDecoderError(
                error: "Failed to decode because it appears to be invalid JSON"
            )
        } catch {
            throw .jsonDecoderError(
                error: "Failed to decode: \(error.localizedDescription)"
            )
        }
    }
}
