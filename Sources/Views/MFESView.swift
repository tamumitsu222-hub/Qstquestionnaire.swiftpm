import SwiftUI

struct MFESView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "MFES",
                        title: "転倒自己効力感尺度（MFES）",
                        description: "各活動を転倒することなくやってのける自信はどれくらいですか？\n0 = 全くない　　10 = 完全にある",
                        progress: state.mfesProgress,
                        answered: state.mfesAnswers.count,
                        total: 14
                    )

                    ForEach(Array(mfesItems.enumerated()), id: \.offset) { i, text in
                        let id = i + 1
                        QuestionCard(
                            number: id,
                            title: text,
                            isDone: state.mfesAnswers[id] != nil
                        ) {
                            ScaleButtonsRow(
                                range: 0...10,
                                leftLabel: "全くない",
                                rightLabel: "完全にある",
                                selectedValue: state.mfesAnswers[id]
                            ) { v in
                                state.mfesAnswers[id] = v
                            }
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("MFES")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
