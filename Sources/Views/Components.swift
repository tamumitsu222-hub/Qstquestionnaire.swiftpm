import SwiftUI

// MARK: - Section Header

struct SectionHeader: View {
    let badge: String
    let title: String
    let description: String
    var badgeColor: Color = .indigo
    var progress: Double
    var answered: Int
    var total: Int

    var body: some View {
        VStack(spacing: 10) {
            Text(badge)
                .font(.system(size: 11, weight: .medium))
                .tracking(1.2)
                .padding(.horizontal, 14).padding(.vertical, 3)
                .background(badgeColor.opacity(0.12))
                .foregroundStyle(badgeColor)
                .clipShape(Capsule())

            Text(title)
                .font(.system(.title3, design: .serif, weight: .semibold))
                .multilineTextAlignment(.center)

            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 4) {
                HStack {
                    Text("\(answered) / \(total) 回答済み")
                    Spacer()
                    Text("\(Int(progress * 100))%")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                ProgressView(value: progress)
                    .tint(badgeColor)
            }
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Question Card

struct QuestionCard<Content: View>: View {
    let number: Int
    let title: String
    var subtitle: String = ""
    var isDone: Bool = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    Circle().fill(isDone ? Color.indigo : Color(.systemGray5))
                    Text("\(number)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(isDone ? .white : .secondary)
                }
                .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13.5, weight: .medium))
                        .fixedSize(horizontal: false, vertical: true)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isDone ? Color.indigo.opacity(0.35) : Color(.systemGray5), lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

// MARK: - Radio Option (vertical list)

struct RadioOptionRow: View {
    let label: String
    var score: String = ""
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if !score.isEmpty {
                    Text(score)
                        .font(.system(size: 10))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
                        .frame(width: 16)
                }
                Text(label)
                    .font(.system(size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(.horizontal, 14).padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.indigo : Color(.systemGray6))
            .foregroundStyle(isSelected ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(isSelected ? Color.indigo : Color(.systemGray4), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Radio Option (horizontal 4-col for BIS/BAS)

struct RadioOptionCell: View {
    let label: String
    var isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8).padding(.horizontal, 4)
                .background(isSelected ? Color.indigo : Color(.systemGray6))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isSelected ? Color.indigo : Color(.systemGray4), lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Scale Buttons Row (0-10 or 1-10)

struct ScaleButtonsRow: View {
    let range: ClosedRange<Int>
    var leftLabel: String = ""
    var rightLabel: String = ""
    var selectedValue: Int?
    var accentColor: Color = .indigo
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 3) {
                ForEach(Array(range), id: \.self) { v in
                    Button {
                        onSelect(v)
                    } label: {
                        Text("\(v)")
                            .font(.system(size: 12, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(selectedValue == v ? accentColor : Color(.systemGray6))
                            .foregroundStyle(selectedValue == v ? .white : .secondary)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedValue == v ? accentColor : Color(.systemGray4), lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            if !leftLabel.isEmpty || !rightLabel.isEmpty {
                HStack {
                    Text(leftLabel).font(.caption2).foregroundStyle(.secondary)
                    Spacer()
                    Text(rightLabel).font(.caption2).foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Section Divider

struct SectionDividerLabel: View {
    let label: String
    var color: Color = .indigo

    var body: some View {
        HStack(spacing: 10) {
            Rectangle().fill(color).frame(height: 2).clipShape(Capsule())
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .tracking(1.0)
                .foregroundStyle(color)
                .fixedSize()
            Rectangle().fill(color).frame(height: 2).clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Next Button

struct NextButton: View {
    let label: String
    var color: Color = .indigo
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 36).padding(.vertical, 12)
                .background(color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Reversed Badge

struct ReversedBadge: View {
    var body: some View {
        Text("逆転")
            .font(.system(size: 9, weight: .medium))
            .padding(.horizontal, 6).padding(.vertical, 1)
            .background(Color.yellow.opacity(0.3))
            .foregroundStyle(Color.orange)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.orange.opacity(0.5), lineWidth: 1))
    }
}
