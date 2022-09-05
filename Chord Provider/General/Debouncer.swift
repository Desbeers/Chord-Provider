//
//  Debouncer.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Debounce a task
actor Debouncer {
    private let duration: TimeInterval
    private var task: Task<Void, Error>?

    init(duration: TimeInterval) {
        self.duration = duration
    }

    func submit(operation: @escaping () async -> Void) {
        task?.cancel()
        
        task = Task {
            try await sleep()
            await operation()
            task = nil
        }
    }
    
    func sleep() async throws {
        try await Task.sleep(nanoseconds: UInt64(duration * TimeInterval(NSEC_PER_SEC)))
    }
}
