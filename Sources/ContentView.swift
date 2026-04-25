import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        TabView {
            Tab("AAE", systemImage: "slider.horizontal.3") {
                AAEView()
            }
            Tab("BIS/BAS", systemImage: "brain.head.profile") {
                BISBASView()
            }
            Tab("FOG-Q", systemImage: "figure.walk") {
                FOGQView()
            }
            Tab("HAMD-17", systemImage: "heart.text.clipboard") {
                HAMDView()
            }
            Tab("MFES", systemImage: "figure.stand") {
                MFESView()
            }
            Tab("mGES", systemImage: "figure.stairs") {
                MGESView()
            }
            Tab("PDSS-2", systemImage: "moon.zzz") {
                PDSS2View()
            }
            Tab("WOQ-9", systemImage: "clock.arrow.2.circlepath") {
                WOQ9View()
            }
            Tab("結果・出力", systemImage: "chart.bar.doc.horizontal") {
                ResultsView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
