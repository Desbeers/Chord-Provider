//
//  OnboardingView.swift
//  Chord Provider
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import DocumentKit

/// Swiftui `View` for the onboarding
struct OnboardingView: View, DocumentGroupModal {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hideWelcome") var hideWelcome: Bool = true
    var body: some View {
        VStack(spacing: 20) {
            WelcomeView()
            HStack {
                Toggle("Do not show this welcome again", isOn: $hideWelcome)
                    .labelsHidden()
                Text("Do not show this welcome again")
            }
            Button("Close") {
                dismiss()
            }
            .padding()
        }
    }
}

extension DocumentGroupToolbarItem {

    static let onboarding = DocumentGroupToolbarItem(icon: .onboarding) {
        try? OnboardingView()
            .presentAsDocumentGroupSheet()
    }
}

extension UIImage {

    static let onboarding = UIImage(systemName: "guitars")
}
