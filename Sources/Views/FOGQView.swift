import SwiftUI

struct FOGQView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "FOG-Q",
                        title: "すくみ足質問票",
                        description: "現在のご自身の状態について、各質問の最も当てはまる回答を選んでください。",
                        progress: state.fogqProgress,
                        answered: state.fogqAnswers.count,
                        total: 6
                    )

                    ForEach(fogqItems) { item in
                        FOGQItemCard(item: item)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("FOG-Q")
            .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        }
    }
}

private struct FOGQItemCard: View {
    @EnvironmentObject var state: AppState
    let item: FOGQItem

    var isDone: Bool { state.fogqAnswers[item.id] != nil }

    var body: some View {
        QuestionCard(number: item.id, title: item.text, isDone: isDone) {
            VStack(spacing: 5) {
                ForEach(Array(item.options.enumerated()), id: \.offset) { i, opt in
                    RadioOptionRow(
                        label: opt,
                        score: "\(i)",
                        isSelected: state.fogqAnswers[item.id] == i
                    ) {
                        state.fogqAnswers[item.id] = i
                    }
                }
            }
        }
    }
}
