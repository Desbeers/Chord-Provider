import Foundation

print("Setup Swift Packages for Flathub.")

let fileManager = FileManager.default

guard let currentDirectoryURL = Process().currentDirectoryURL else {
    fatalError()
}
let flatpakSwiftDir = currentDirectoryURL.appending(path: ".flatpak/swift")
try? fileManager.createDirectory(at: flatpakSwiftDir, withIntermediateDirectories: true)

/// Parse the dependencies in the workspace state file.
let workspaceStateURL = currentDirectoryURL.appending(path: "/.build/workspace-state.json")
guard 
    let data = try? Data(contentsOf: workspaceStateURL),
    let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data)
else {
    fatalError()
}

// Copy the names of the folders under "{path}/.build/repositories".
let repositoriesURL = currentDirectoryURL.appending(component: ".build/repositories")
let repositoriesContent = try fileManager.contentsOfDirectory(at: repositoriesURL, includingPropertiesForKeys: nil)

// Generate the JSON file with the sources and the shell script for tweaks.
var content = """
[
"""
var shellContent = """
#!/usr/bin/env bash
mkdir .flatpak/swift/repositories
cd .flatpak/swift/repositories
"""

for dependency in workspaceState.object.dependencies {
    let subpath = dependency.subpath
    content.append("""
        {
            "type": "git",
            "url": "\(dependency.packageRef.location)",
            "disable-shallow-clone": true,
            "commit": "\(dependency.state.checkoutState.revision)",
            "dest": ".flatpak/swift/checkouts/\(subpath)"
        },

    """)
    let folders = repositoriesContent.map(\.lastPathComponent).filter { $0.hasPrefix(subpath + "-") }
    for folder in folders {
        shellContent.append("""

        mkdir ./\(folder)
        cp -r ../checkouts/\(subpath)/.git/* ./\(folder)
        """)
    }
}
content.append("""

    {
         "type": "file",
         "path": ".flatpak/swift/setup-offline.sh"
    }
""")
content.append("\n]")



let setupURL = flatpakSwiftDir.appending(path: "/setup-offline.sh")

let contentData = content.data(using: .utf8)
let shellContentData = shellContent.data(using: .utf8)
try contentData?.write(to: flatpakSwiftDir.appending(path: "git-sources.json"))
try shellContentData?.write(to: setupURL)

let executable = Process()
executable.executableURL = URL(fileURLWithPath: "/usr/bin/env")
executable.arguments = ["chmod", "+x", setupURL.path]
try executable.run()
executable.waitUntilExit()

print("Setup done.")

// Types for decoding workspace state file.
struct Dependency: Codable {

    var packageRef: PackageRef
    var state: State
    var subpath: String

    struct PackageRef: Codable {

        var location: String

    }

    struct State: Codable {

        var checkoutState: CheckoutState

    }

    struct CheckoutState: Codable {

        var revision: String

    }

}

struct WorkspaceState: Codable {

    var object: Object

    struct Object: Codable {

        var dependencies: [Dependency]

    }

}
