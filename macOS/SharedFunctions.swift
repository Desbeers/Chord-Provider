// MARK: - functions that are specific for macOS

import SwiftUI

struct FancyBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    return NSVisualEffectView()
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}
