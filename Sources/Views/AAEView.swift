import SwiftUI

struct AAEView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        @Bindable var s = state
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12, pinnedViews: []) {
                    SectionHeader(
                        badge: "AAE",
                        title: "AAE 尺度（形容詞属性評価）",
                        description: "各特性について自分の位置をスライダーで答えてください。\n左端=0（一番〇〇でない人）  中央=50（平均）  右端=100（一番〇〇な人）",
                        progress: state.aaeProgress,
                        answered: state.aaeTouched.count,
                        total: 60
                    )

                    ForEach(aaeSections, id: \.label) { sec in
                        SectionDividerLabel(label: sec.label)
                        ForEach(aaeItems.filter { $0.valence == sec.valence }) { item in
                            AAEItemCard(item: item)
                        }
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("AAE 尺度")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct AAEItemCard: View {
    @Environment(AppState.self) private var state
    let item: AAEItem

    var isDone: Bool { state.aaeTouched.contains(item.id) }

    var body: some View {
        @Bindable var s = state
        QuestionCard(number: item.id, title: item.word, isDone: isDone) {
            VStack(spacing: 6) {
                HStack {
                    Text(item.leftLabel)
                    Spacer()
                    Text("50=平均")
                        .foregroundStyle(Color(.systemGray3))
                    Spacer()
                    Text(item.rightLabel)
                }
                .font(.system(size: 10))
                .foregroundStyle(.secondary)

                HStack(spacing: 10) {
                    Slider(
                        value: Binding(
                            get: { state.aaeValues[item.id] ?? 50.0 },
                            set: { v in
                                state.aaeValues[item.id] = v
                                state.aaeTouched.insert(item.id)
                            }
                        ),
                        in: 0...100,
                        step: 1,
                        onEditingChanged: { editing in
                            if editing { state.aaeTouched.insert(item.id) }
                        }
                    )
                    .tint(.indigo)

                    Text("\(Int(state.aaeValues[item.id] ?? 50))")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.indigo)
                        .frame(width: 32)
                        .padding(.vertical, 3)
                        .background(Color(.systemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
    }
}
