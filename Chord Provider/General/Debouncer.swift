//
//  Debouncer.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Debounce a task
actor Debouncer {
    /// The duration of the debounce
    private let duration: TimeInterval
    /// The `Task` to debounce
    private var task: Task<Void, Error>?

    /// Init the ``Debouncer``
    /// - Parameter duration: Time duration to debounce
    init(duration: TimeInterval) {
        self.duration = duration
    }

    /// Submit a debounce `Task`
    /// - Parameter operation: The `Task`
    func submit(operation: @escaping () async -> Void) {
        task?.cancel()
        task = Task {
            try await sleep()
            await operation()
            task = nil
        }
    }

    /// Let a `Task` sleep
    func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * TimeInterval(NSEC_PER_SEC)))
    }
}
