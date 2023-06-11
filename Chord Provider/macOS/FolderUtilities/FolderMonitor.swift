//
//  FolderMonitor.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import Foundation

/// A class to monitor folders  for changes
public class FolderMonitor {
    /// The method when a folder did change
    public var folderDidChange: (() -> Void)?
    /// The kernel event queue ID
    private let kqueueID: Int32
    private var watchedPaths = [URL: Int32]()
    private var keepWatcherThreadRunning = false
    private let folderChangeDebouncer = DebounceTask(duration: 2)
    public init() {
        /// Create a kernel event queue using the system call `kqueue`. This returns a file descriptor.
        kqueueID = kqueue()
        if kqueueID == -1 {
            print("Error creating kqueue")
            preconditionFailure()
        }
    }

    deinit {
        keepWatcherThreadRunning = false
        removeAllURLs()
        close(kqueueID)
    }

    /// Add a folder and all its subfolders to observe for changes
    /// - Parameter url: URL of the folder
    public func addRecursiveURL(_ url: URL) {
        if url.hasDirectoryPath {
            let options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles, .skipsPackageDescendants]
            removeAllURLs()
            addURL(url)
            if let items = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil, options: options) {
                while let item = items.nextObject() as? URL {
                    if item.hasDirectoryPath {
                        addURL(item)
                    }
                }
            }
        }
    }

    public func addURL(_ url: URL) {
        /// Check if the file descriptor for the URL is already known
        var fileDescriptor: Int32! = watchedPaths[url]
        /// If not, create a file descriptor
        if fileDescriptor == nil {
            fileDescriptor = open(FileManager.default.fileSystemRepresentation(withPath: url.path), O_EVTONLY)
            guard fileDescriptor >= 0 else {
                return
            }
            watchedPaths[url] = fileDescriptor
        }
        /// Create the kevent structure that sets up our kqueue to listen for notifications
        var edit = kevent(
            /// Identifier for this event
            ident: UInt(fileDescriptor),
            /// Filter for event
            filter: Int16(EVFILT_VNODE),
            /// General flags
            flags: UInt16(EV_ADD | EV_CLEAR),
            /// Filter-specific flags
            fflags: UInt32(NOTE_WRITE),
            /// Filter-specific data
            data: 0,
            /// Opaque user data identifier
            udata: nil
        )
        /// This is where the kqueue is register with our
        /// interest for the notifications described by
        /// our kevent structure `edit`
        kevent(kqueueID, &edit, 1, nil, 0, nil)

        if !keepWatcherThreadRunning {
            keepWatcherThreadRunning = true
            Task {
                watcherThread()
            }
        }
    }

    private func watcherThread() {
        var event = kevent()
        var timeout = timespec(tv_sec: 1, tv_nsec: 0)
        while keepWatcherThreadRunning {
            if kevent(kqueueID, nil, 0, &event, 1, &timeout) > 0 && event.filter == EVFILT_VNODE && event.fflags > 0 {
                Task {
                    await folderChangeDebouncer.submit {
                        self.folderDidChange?()
                    }
                }
            }
        }
    }

    public func isURLWatched(_ url: URL) -> Bool {
        return watchedPaths[url] != nil
    }

    public func removeURL(_ url: URL) {
        if let fileDescriptor = watchedPaths.removeValue(forKey: url) {
            close(fileDescriptor)
        }
    }

    public func removeAllURLs() {
        watchedPaths.keys.forEach(removeURL)
    }

    public func numberOfWatchedPaths() -> Int {
        return watchedPaths.count
    }

    public func fileDescriptorForURL(_ url: URL) -> Int32 {
        if let fileDescriptor = watchedPaths[url] {
            return fcntl(fileDescriptor, F_DUPFD)
        }
        return -1
    }
}

private extension FolderMonitor {

    /// Debounce a task
    actor DebounceTask {
        /// The duration of the debounce
        private let duration: TimeInterval
        /// The `Task` to debounce
        private var task: Task<Void, Error>?

        /// Init the DebounceTask
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
}
