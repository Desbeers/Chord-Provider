import SwiftUI

@main
struct ChordProviderApp: App {
    /// Get the list of chord diagrams so we don't have to parse it all the time.
    @State var diagrams = Diagram.all
    
    var body: some Scene {
        DocumentGroup(newDocument: ChordProDocument()) { file in
            MainView(document: file.$document, diagrams: $diagrams)
        }
    }
}
