import Foundation
import Adwaita

/// The main `View` for the application
struct Main: View {

    @State var selectedTab: Tab = .separator

    @State var eitherToggle: Bool = false

    var view: Body {
        VStack {
            ToggleGroup(selection: $selectedTab, values: Tab.allCases, id: \.self, label: \.rawValue)
            ScrollView {
                switch selectedTab {
                case .separator:
                    separators
                case .forEach:
                    foreach
                case .either:
                    either
                case .switching:
                    switching
                }
            }
            .vexpand()
            .hexpand()
        }
    }

    var separators: AnyView {
        VStack(spacing: 10) {
            Text("Separators know their orientation from their parent")
                .accent()
            Text("In VStack")
                .title2()
            VStack(spacing: 5) {
                Text(Filler.left.rawValue)
                Separator()
                Text(Filler.right.rawValue)
            }
            .padding()
            .card()
            status("This is OK, but only because its the default")
                .accent()
            Text("In HStack")
                .title2()
            HStack(spacing: 5) {
                Text(Filler.left.rawValue)
                Separator()
                Text(Filler.right.rawValue)
            }
            .padding()
            .card()
            status("This is OK, but I expect all childeren the same width and centered")
                .warning()
            Text("In CenterBox")
                .title2()
            CenterBox()
                .startWidget {
                    Text(Filler.left.rawValue)
                }
                .centerWidget {
                    Separator()
                }
                .endWidget {
                    Text(Filler.right.rawValue)
                }
                .padding()
                .card()
            status("This is OK but needs a more <i>Swifty</i> init() and left and right should be centered")
                .warning()
        }
    }

    var foreach: AnyView {
        VStack(spacing: 10) {
            Text("ForEch does not know the orientation of its parent")
                .error()
             Text("In VStack")
                .title2()
            VStack(spacing: 5) {
                ForEach(Filler.numbers, id: \.rawValue) { number in
                    Text(number.rawValue)
                }
            }
            .padding()
            .card()
            status("This is OK")
                .accent()
            Text("In HStack")
                .title2()
            VStack(spacing: 5) {
                ForEach(Filler.numbers, id: \.rawValue) { number in
                    Text(number.rawValue)
                }
            }
            .padding()
            .card()
            status("This is not OK, I expect the elements horizontal but it will default to vertical and I have to set the orientation specific myself")
                .error()
        }
    }

    var either: AnyView {
        VStack(spacing: 10) {
            Text("EitherView does not know their orientation from their parent")
                .error()
            Toggle("Toggle Either", isOn: $eitherToggle)
                .halign(.center)
            Text("In VStack")
                .title2()
            VStack(spacing: 5) {
                EitherView(
                    eitherToggle,
                    view1: {
                        Text(Filler.left.rawValue)
                        Separator()
                        Text(Filler.right.rawValue)
                    },
                    else: {
                        Text(Filler.one.rawValue)
                        Separator()
                        Text(Filler.two.rawValue)
                    }
                )
                .padding()
                .card()
            }
            status("This is OK")
                .accent()
            Text("In HStack")
                .title2()
            HStack(spacing: 5) {
                EitherView(
                    eitherToggle,
                    view1: {
                        Text(Filler.left.rawValue)
                        Separator()
                        Text(Filler.right.rawValue)
                    },
                    else: {
                        Text(Filler.one.rawValue)
                        Separator()
                        Text(Filler.two.rawValue)
                    }
                )
                .padding()
                .card()
            }
            status("This is not OK, it should be aligned horizontal")
                .error()
            Text("Notice the different alignments?")
                .title4()
        }
    }

    var switching: AnyView {
        VStack(spacing: 10) {
            Text("Switch will reset the orientation of its parent")
                .error()
            Toggle("Toggle Switch", isOn: $eitherToggle)
                .halign(.center)
            Text("In VStack")
                .title2()
            VStack(spacing: 5) {
                switch eitherToggle {
                case true:
                    Text(Filler.left.rawValue)
                    Separator()
                    Text(Filler.right.rawValue)
                case false:
                    Text(Filler.one.rawValue)
                    Separator()
                    Text(Filler.two.rawValue)
                }
            }
            .padding()
            .card()
            status("This is OK")
                .accent()
            Text("In HStack")
                .title2()
            HStack(spacing: 5) {
                switch eitherToggle {
                case true:
                    Text(Filler.left.rawValue)
                    Separator()
                    Text(Filler.right.rawValue)
                case false:
                    Text(Filler.one.rawValue)
                    Separator()
                    Text(Filler.two.rawValue)
                }
            }
            .padding()
            .card()
            status("This is not OK, it should be aligned horizontal")
                .error()
            Text("Notice the different alignments?")
                .title4()
        }
    }    

    func status(_ text: String) -> AnyView {
        Text(text)
            .useMarkup()
            .caption()
    }
}
