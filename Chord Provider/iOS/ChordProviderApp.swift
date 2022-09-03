//
//  ChordProviderApp.swift
//  Chord Provider
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The scene for the application
@main struct ChordProviderApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            ViewContent(document: file.$document, file: file.fileURL ?? nil)
                .navigationBarHidden(true)
        }
    }
}


/// Close the scene and go back to the file selector
///
/// 'DocumentGroup' has a bug; it shows a 'double' *go back* arrow.
/// I solved this by hiding the navigation bar and make my own *go back*.
/// Because it's almost impossible to get the 'current' scene I limited the application to only one scene.
///
/// See: [this Stack Overflow page](https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0)
func goBack() {
    if let keyWindow = UIApplication.shared.mainKeyWindow {
        keyWindow.rootViewController?.dismiss(animated: true)    }
    
}

extension UIApplication {
    
    /// Get the keyWindow
    var mainKeyWindow: UIWindow? {
        return connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
