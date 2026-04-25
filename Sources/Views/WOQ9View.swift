import SwiftUI

struct WOQ9View: View {
    @Environment(AppState.self) private var state

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    SectionHeader(
                        badge: "WOQ-9",
                        title: "ウェアリング・オフ チェックリスト",
                        description: "ステップ1：最近1日の中でこの症状が「ある」か「ない」か\nステップ2：「ある」の症状は、レボドパなどを飲めば「軽くなる」か「変わらない」か",
                        progress: state.woq9Progress,
                        answered: state.woq9S1.count,
                        total: 9
                    )

                    ForEach(Array(woq9Symptoms.enumerated()), id: \.offset) { i, sym in
                        WOQ9ItemCard(id: i + 1, symptom: sym)
                    }

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("WOQ-9")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct WOQ9ItemCard: View {
    @Environment(AppState.self) private var state
    let id: Int
    let symptom: String

    var s1: Bool? { state.woq9S1[id] }
    var s2: Bool? { state.woq9S2[id] }
    var isDone: Bool { s1 != nil }
    var step2Enabled: Bool { s1 == true }

    var body: some View {
        QuestionCard(number: id, title: symptom, isDone: isDone) {
            VStack(spacing: 10) {
                // Step 1
                VStack(alignment: .leading, spacing: 6) {
                    Text("ステップ1").font(.system(size: 11, weight: .bold)).foregroundStyle(.blue)
                    HStack(spacing: 8) {
                        ToggleButton(
                            label: "ある",
                            isActive: s1 == true,
                            activeColor: .blue
                        ) {
                            state.woq9S1[id] = true
                        }
                        ToggleButton(
                            label: "ない",
                            isActive: s1 == false,
                            activeColor: Color(.systemGray3)
                        ) {
                            state.woq9S1[id] = false
                            state.woq9S2.removeValue(forKey: id)
                        }
                    }
                }

                // Step 2
                VStack(alignment: .leading, spacing: 6) {
                    Text("ステップ2").font(.system(size: 11, weight: .bold)).foregroundStyle(.purple)
                    HStack(spacing: 8) {
                        ToggleButton(
                            label: "飲めば軽くなる",
                            isActive: s2 == true,
                            activeColor: .purple
                        ) {
                            state.woq9S2[id] = true
                        }
                        ToggleButton(
                            label: "変わらない",
                            isActive: s2 == false,
                            activeColor: Color(.systemGray3)
                        ) {
                            state.woq9S2[id] = false
                        }
                    }
                }
                .opacity(step2Enabled ? 1 : 0.35)
                .disabled(!step2Enabled)
            }
        }
    }
}

private struct ToggleButton: View {
    let label: String
    var isActive: Bool
    var activeColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isActive ? activeColor : Color(.systemGray6))
                .foregroundStyle(isActive ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isActive ? activeColor : Color(.systemGray4), lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}
