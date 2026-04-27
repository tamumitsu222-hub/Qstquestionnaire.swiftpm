import SwiftUI

private let bbOptions = ["あてはまらない", "ややあてはまらない", "ややあてはまる", "あてはまる"]

struct BISBASView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "BIS/BAS",
                        title: "BIS/BAS 尺度（日本語版）",
                        description: "各文章があなたにどの程度あてはまるかお答えください。",
                        progress: state.bisbasProgress,
                        answered: state.bisbasAnswers.count,
                        total: 20
                    )

                    ForEach(bisbasSections) { sec in
                        SectionDividerLabel(label: sec.label)
                        ForEach(sec.itemIDs, id: \.self) { id in
                            if let item = bisbasItems.first(where: { $0.id == id }) {
                                BISBASItemCard(item: item)
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("BIS/BAS")
            .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        }
    }
}

private struct BISBASItemCard: View {
    @EnvironmentObject var state: AppState
    let item: BISBASItem

    var isDone: Bool { state.bisbasAnswers[item.id] != nil }

    var body: some View {
        QuestionCard(number: item.id, title: item.text, isDone: isDone) {
            if item.reversed {
                HStack { ReversedBadge(); Spacer() }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 4), spacing: 5) {
                ForEach(Array(bbOptions.enumerated()), id: \.offset) { i, label in
                    RadioOptionCell(
                        label: label,
                        isSelected: state.bisbasAnswers[item.id] == i + 1
                    ) {
                        state.bisbasAnswers[item.id] = i + 1
                    }
                }
            }
        }
    }
}
