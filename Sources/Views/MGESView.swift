import SwiftUI

struct MGESView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "mGES",
                        title: "日本語版 改訂 Gait Efficacy Scale",
                        description: "自信の程度を1〜10で当てはまる番号を選んでください。\n1 = まったく自信がない　　10 = 完全に自信がある",
                        progress: state.mgesProgress,
                        answered: state.mgesAnswers.count,
                        total: 10
                    )

                    ForEach(Array(mgesItems.enumerated()), id: \.offset) { i, text in
                        let id = i + 1
                        QuestionCard(
                            number: id,
                            title: text,
                            isDone: state.mgesAnswers[id] != nil
                        ) {
                            ScaleButtonsRow(
                                range: 1...10,
                                leftLabel: "自信なし",
                                rightLabel: "完全に自信あり",
                                selectedValue: state.mgesAnswers[id]
                            ) { v in
                                state.mgesAnswers[id] = v
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("mGES")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
