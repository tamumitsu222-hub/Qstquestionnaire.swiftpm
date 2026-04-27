import SwiftUI

struct ResultsView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Metadata input
                    MetadataCard()

                    // Export button
                    ShareLink(item: state.csvFileURL()) {
                        Label("CSVファイルをダウンロード", systemImage: "arrow.down.doc.fill")
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 28).padding(.vertical, 12)
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)

                    // Score grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ScoreBox(title: "AAE 尺度", subtitle: "形容詞属性評価（60項目）") {
                            let s = state.aaeScore
                            ScoreRow(label: "ポジティブ語平均", value: "\(s.posAvg)", maxVal: "100")
                            ScoreRow(label: "ネガティブ語平均", value: "\(s.negAvg)", maxVal: "100")
                            ScoreRow(label: "総合スコア",       value: "\(s.totalAvg)", maxVal: "100")
                        }

                        ScoreBox(title: "BIS/BAS 尺度", subtitle: "行動抑制/活性化（20項目）") {
                            let s = state.bisbasScore
                            ScoreRow(label: "BIS（行動抑制）",  value: "\(s.bis)",        maxVal: "28")
                            ScoreRow(label: "BAS-Drive",       value: "\(s.drive)",      maxVal: "16")
                            ScoreRow(label: "BAS-Fun Seeking", value: "\(s.funSeeking)", maxVal: "16")
                            ScoreRow(label: "BAS-報酬反応性",   value: "\(s.rr)",         maxVal: "20")
                        }

                        ScoreBox(title: "FOG-Q", subtitle: "すくみ足質問票（6項目）") {
                            ScoreRow(label: "合計スコア", value: "\(state.fogqTotal)", maxVal: "24")
                        }

                        ScoreBox(title: "GRID-HAMD-17", subtitle: "うつ病評価尺度（17項目）") {
                            ScoreRow(label: "合計スコア", value: "\(state.hamdTotal)", maxVal: "52")
                            HStack {
                                Text("重症度")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(state.hamdSeverityLabel)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(.indigo)
                                    .multilineTextAlignment(.trailing)
                            }
                        }

                        ScoreBox(title: "MFES", subtitle: "転倒自己効力感（14項目）") {
                            ScoreRow(label: "合計スコア", value: "\(state.mfesTotal)", maxVal: "140")
                        }

                        ScoreBox(title: "mGES", subtitle: "歩行自己効力感（10項目）") {
                            ScoreRow(label: "合計スコア", value: "\(state.mgesTotal)", maxVal: "100")
                        }

                        ScoreBox(title: "PDSS-2", subtitle: "PD睡眠評価（15項目）") {
                            ScoreRow(label: "合計スコア", value: "\(state.pdss2Total)", maxVal: "60")
                        }

                        ScoreBox(title: "WOQ-9", subtitle: "ウェアリング・オフ（9項目）") {
                            let wq = state.woqResult
                            ScoreRow(label: "Step1 症状あり数",    value: "\(wq.s1)", maxVal: "9")
                            ScoreRow(label: "Step2 服薬で軽減数", value: "\(wq.s2)", maxVal: "9")
                            HStack {
                                Text("WO判定")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(wq.positive ? "陽性" : "陰性")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(wq.positive ? .red : .green)
                            }
                        }
                    }

                    // Citation
                    Text("""
AAE: 伊里綾香 ら  |  BIS/BAS: Carver & White (1994); 高橋雄介他 (2007)  |  FOG-Q: Giladi et al. (2000)
GRID-HAMD-17: Williams et al. (2008)  |  MFES: Hill et al. (1996)  |  mGES: 牧迫飛雄馬他 (2013)
PDSS-2: Suzuki et al. (2012)  |  WOQ-9: 関 守信 監修
""")
                    .font(.system(size: 10))
                    .foregroundStyle(Color(.systemGray3))
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("結果・出力")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Metadata Card

private struct MetadataCard: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                TextField("被験者ID", text: $state.participantID)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 180)
            }
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                DatePicker("", selection: $state.evaluationDate, displayedComponents: .date)
                    .labelsHidden()
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1.5))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

// MARK: - Score Box / Row

private struct ScoreBox<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
            Text(subtitle)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
            Divider()
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1.5))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }
}

private struct ScoreRow: View {
    let label: String
    let value: String
    let maxVal: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(.title3, design: .serif, weight: .semibold))
                .foregroundStyle(.indigo)
            Text("/ \(maxVal)")
                .font(.system(size: 11))
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(.vertical, 1)
    }
}
