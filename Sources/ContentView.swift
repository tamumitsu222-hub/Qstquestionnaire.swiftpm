import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        TabView {
            AAEView()
                .tabItem { Label("AAE", systemImage: "slider.horizontal.3") }
            BISBASView()
                .tabItem { Label("BIS/BAS", systemImage: "brain") }
            FOGQView()
                .tabItem { Label("FOG-Q", systemImage: "figure.walk") }
            HAMDView()
                .tabItem { Label("HAMD-17", systemImage: "list.clipboard") }
            MFESView()
                .tabItem { Label("MFES", systemImage: "figure.stand") }
            MGESView()
                .tabItem { Label("mGES", systemImage: "arrow.up.forward.circle") }
            PDSS2View()
                .tabItem { Label("PDSS-2", systemImage: "moon.zzz") }
            WOQ9View()
                .tabItem { Label("WOQ-9", systemImage: "clock.arrow.circlepath") }
            ResultsView()
                .tabItem { Label("結果・出力", systemImage: "chart.bar.doc.horizontal") }
        }
    }
}
