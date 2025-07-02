//
//  SettingsCache.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import Foundation

/// Get and set ``AppSettings`` to the cache directory
/// - Note: This is used to get and save the application settings
enum SettingsCache {

    /// Get a struct from the cache
    /// - Parameters:
    ///   - id: The ID of the settings
    ///   - struct: The struct to use for decoding
    /// - Returns: decoded cache item
    static func get<T: Codable>(id: AppSettings.AppWindowID, struct: T.Type) throws -> T {
        let file = try self.path(for: id)
        let data = try Data(contentsOf: file)
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Save a struct into the cache
    /// - Parameters:
    ///   - id: The ID of the settings
    ///   - object:The struct to save
    /// - Throws: an error if it can't be saved
    static func set<T: Codable>(id: AppSettings.AppWindowID, object: T) throws {
        let file = try self.path(for: id)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let archivedValue = try encoder.encode(object)
        try archivedValue.write(to: file)
    }

    /// Delete a struct from the cache
    /// - Parameter id: The ID of the settings
    /// - Throws: an error if it can't be saved
    static func delete(id: AppSettings.AppWindowID) throws {
        let file = try self.path(for: id)
        try FileManager.default.removeItem(atPath: file.path)
    }

    /// Get the path to the cache directory
    /// - Parameter key: id: The ID of the settings
    /// - Returns: A full ``URL`` to the cache directory
    private static func path(for id: AppSettings.AppWindowID) throws -> URL {
        let bundleID = Bundle.main.bundleIdentifier ?? "nl.desbeers.chordprovider"
        let manager = FileManager.default
        let rootFolderURL = manager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        let nestedFolderURL = rootFolderURL[0].appending(path: bundleID)
        /// Create the directory
        try? FileManager.default.createDirectory(at: nestedFolderURL, withIntermediateDirectories: true)
        return nestedFolderURL.appendingPathComponent(id.rawValue, conformingTo: .json)
    }
}
