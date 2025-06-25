//
//  SplitterView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

/// SwiftUI `View` for the splitter between editor and preview pane
///
/// I don't use a `HSplitView` because its very limited in its usage
struct SplitterView: View {
    /// Bool if the splitter is currently dragging
    @State private var isDragging = false
    /// The offset of the splitter while dragging
    @State private var offset = CGSize.zero
    /// The observable state of the scene
    @Environment(SceneStateModel.self) private var sceneState
    /// The body of the `View`
    var body: some View {
        Rectangle()
            .fill(isDragging ? .accentColor : Color(NSColor.separatorColor))
            .pointerStyle(.columnResize)
            .zIndex(1000)
            .frame(width: 2)
            .offset(x: offset.width)
            .onHover { hover in
                isDragging = hover
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isDragging = true
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        sceneState.isAnimating = true
                        /// Hide the editor when its too small
                        if (sceneState.windowWidth / 2) + sceneState.editorOffset + offset.width < 300 {
                            withAnimation {
                                sceneState.showEditor.toggle()
                            } completion: {
                                sceneState.isAnimating = false
                            }
                        } else {
                            withAnimation {
                                sceneState.editorOffset += offset.width
                            } completion: {
                                sceneState.isAnimating = false
                            }
                        }
                        isDragging = false
                        offset = .zero
                    }
            )
    }
}
