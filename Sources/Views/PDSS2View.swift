import SwiftUI

struct PDSS2View: View {
    @Environment(AppState.self) private var state

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "PDSS-2",
                        title: "パーキンソン病睡眠評価尺度-2",
                        description: "過去7日間の体験に基づき、各項目について最も当てはまる回答を選んでください。",
                        progress: state.pdss2Progress,
                        answered: state.pdss2Answers.count,
                        total: 15
                    )

                    ForEach(pdss2Items) { item in
                        PDSS2ItemCard(item: item)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PDSS-2")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct PDSS2ItemCard: View {
    @Environment(AppState.self) private var state
    let item: PDSS2Item

    var isDone: Bool { state.pdss2Answers[item.id] != nil }
    var options: [(label: String, score: Int)] {
        item.reversed ? pdss2OptionsReversed : pdss2OptionsNormal
    }

    var body: some View {
        QuestionCard(number: item.id, title: item.text, isDone: isDone) {
            if item.reversed {
                HStack { ReversedBadge(); Spacer() }
            }
            VStack(spacing: 5) {
                ForEach(options, id: \.label) { opt in
                    RadioOptionRow(
                        label: opt.label,
                        isSelected: state.pdss2Answers[item.id] == opt.score
                    ) {
                        state.pdss2Answers[item.id] = opt.score
                    }
                }
            }
        }
    }
}
