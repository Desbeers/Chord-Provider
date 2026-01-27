//
//  Debouncer.swift
//  GTKSourceView
//
//  © 2025 Nick Berendsen
//

import Foundation
import CSourceView

/// A simple GTK debouncer to update the UI
final class Debouncer {
    /// The debounce delay
    private let delayMS: guint
    /// The ID of the task
    private var sourceID: guint = 0
    /// Init the debouncer class with its delay
    /// - Parameter delay: The debounce delay
    init(delay: TimeInterval) {
        self.delayMS = guint(delay * 1000)
    }
    /// Deinit the debouncer class
    deinit {
        cancel()
    }
    /// Schedule a task
    /// - Parameter task: The task
    func schedule(_ task: @escaping () -> Void) {
        /// Cancel the current task
        cancel()
        /// Wrap the task in a class
        let closureTask = ClosureTask(task)
        /// Define a new source ID
        sourceID = g_timeout_add_full(
            G_PRIORITY_DEFAULT_IDLE,
            delayMS,
            { userData in
                guard let userData else { return G_SOURCE_REMOVE }

                let closure = Unmanaged<ClosureTask>
                    .fromOpaque(userData)
                    .takeRetainedValue()

                closure.task()
                return G_SOURCE_REMOVE
            },
            Unmanaged.passRetained(closureTask).toOpaque(),
            nil
        )
    }
    /// Cancel current task
    func cancel() {
        /// Check if there is actually something to cancel
        guard sourceID != 0 else { return }
        /// Find the source
        if let source = g_main_context_find_source_by_id(nil, sourceID) {
            g_source_destroy(source)
        }
        /// Reset the source ID
        sourceID = 0
    }
}

extension Debouncer {

    /// Class wrapper for the task so it can be handed by `C`
    final class ClosureTask {
        /// The task to execute
        let task: () -> Void
        /// Init the closure in a class
        init(_ task: @escaping () -> Void) {
            self.task = task
        }
    }
}
