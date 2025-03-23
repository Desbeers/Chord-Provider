//
//  FontPickerView.swift
//  Chord Provider
//
//  © 2025 Nick Berendsen
//

import SwiftUI

class FontPickerDelegate {
    var parent: FontPickerView

    init(_ parent: FontPickerView) {
        self.parent = parent
    }

    @objc @MainActor
    func changeFont(_ id: Any) {
        parent.fontSelected()
    }
}

struct FontPickerView: View {

    @State var font: NSFont


    @Binding var fontOptions: ConfigOptions.FontOptions

    @State var fontPickerDelegate: FontPickerDelegate?

    let config: ChordPro.FontConfig

    let settings: AppSettings.PDF

    init(config: ChordPro.FontConfig, options: Binding<ConfigOptions.FontOptions>, settings: AppSettings.PDF) {

        let font = NSFont(name: options.font.wrappedValue, size: options.size.wrappedValue) ?? .systemFont(ofSize: 10)
        self._fontOptions = options
        self._font = State(initialValue: font)
        self.settings = settings
        self.config = config
    }

    var body: some View {
        HStack {
            Button {
                if NSFontPanel.shared.isVisible {
                    NSFontPanel.shared.orderOut(nil)

                    if NSFontManager.shared.target === self.fontPickerDelegate {
                        return
                    }
                }

                self.fontPickerDelegate = FontPickerDelegate(self)
                NSFontManager.shared.target = self.fontPickerDelegate

                NSFontPanel.shared.setPanelFont(self.font, isMultiple: false)
                NSFontPanel.shared.orderBack(nil)
            } label: {
                Text("Select")
            }
            Text(font.familyName ?? "Selected Font")
                .font(.custom(font.fontName, size: font.pointSize * 1.2))
                .foregroundStyle(config.color(settings: settings))
        }
        .animation(.default, value: font)
        .task(id: font) {
            fontOptions.font = font.fontName
            fontOptions.size = font.pointSize
        }
        .task(id: fontOptions) {
            font = NSFont(name: fontOptions.font, size: fontOptions.size) ?? .systemFont(ofSize: 10)
            NSFontPanel.shared.setPanelFont(font, isMultiple: false)
        }
    }

    func fontSelected() {
        self.font = NSFontPanel.shared.convert(self.font)
    }
}
