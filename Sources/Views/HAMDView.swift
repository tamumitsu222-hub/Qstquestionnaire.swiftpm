import SwiftUI

struct HAMDView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "GRID-HAMD-17",
                        title: "GRID-ハミルトンうつ病評価尺度",
                        description: "過去1週間の状態について、①症状の程度を選んだ後、②どれくらいの頻度かを選んでください。",
                        progress: state.hamdProgress,
                        answered: state.hamdScore.count,
                        total: 17
                    )

                    ForEach(hamdItems) { item in
                        HAMDItemCard(item: item)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("HAMD-17")
            .navigationBarTitleDisplayMode(.inline)
        .navigationViewStyle(.stack)
        }
    }
}

private struct HAMDItemCard: View {
    @EnvironmentObject var state: AppState
    let item: HAMDItem

    var isDone: Bool { state.hamdScore[item.id] != nil }
    var currentSev: Int? { state.hamdSeverity[item.id] }
    var freqEnabled: Bool { item.type == .grid && (currentSev ?? 0) > 0 }

    var body: some View {
        QuestionCard(number: item.id, title: item.name, subtitle: item.note, isDone: isDone) {
            VStack(spacing: 10) {
                // Step 1: Severity
                VStack(alignment: .leading, spacing: 6) {
                    Text("①程度")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.indigo)

                    VStack(spacing: 5) {
                        ForEach(Array(item.severityOptions.enumerated()), id: \.offset) { i, opt in
                            RadioOptionRow(
                                label: opt,
                                score: "\(i)",
                                isSelected: state.hamdSeverity[item.id] == i
                            ) {
                                state.hamdSeverity[item.id] = i
                                if item.type == .grid && i == 0 {
                                    state.hamdFrequency.removeValue(forKey: item.id)
                                }
                                state.updateHAMDScore(itemID: item.id)
                            }
                        }
                    }
                }

                // Step 2: Frequency (grid type only)
                if item.type == .grid {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("②頻度")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(freqEnabled ? Color.teal : .secondary)

                        VStack(spacing: 5) {
                            ForEach(Array(hamdFrequencyOptions.enumerated()), id: \.offset) { i, opt in
                                RadioOptionRow(
                                    label: opt,
                                    score: "\(i)",
                                    isSelected: state.hamdFrequency[item.id] == i
                                ) {
                                    state.hamdFrequency[item.id] = i
                                    state.updateHAMDScore(itemID: item.id)
                                }
                            }
                        }
                        .opacity(freqEnabled ? 1 : 0.3)
                        .disabled(!freqEnabled)
                    }
                    .padding(12)
                    .background(Color.teal.opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.teal.opacity(freqEnabled ? 0.3 : 0.1), lineWidth: 1.5)
                    )
                }

                // Score display
                if let score = state.hamdScore[item.id] {
                    HStack {
                        Spacer()
                        Text("得点: ")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(score)点")
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10).padding(.vertical, 2)
                            .background(Color.indigo.opacity(0.12))
                            .foregroundStyle(.indigo)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}
