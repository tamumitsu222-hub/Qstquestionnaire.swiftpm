import SwiftUI
import Observation

@Observable
class AppState {
    // MARK: - Metadata
    var participantID: String = ""
    var evaluationDate: Date = Date()

    // MARK: - AAE (VAS 0-100, default 50)
    var aaeValues: [Int: Double] = (1...60).reduce(into: [:]) { $0[$1] = 50.0 }
    var aaeTouched: Set<Int> = []

    // MARK: - BIS/BAS (1-4)
    var bisbasAnswers: [Int: Int] = [:]

    // MARK: - FOG-Q (0-4)
    var fogqAnswers: [Int: Int] = [:]

    // MARK: - HAMD
    var hamdSeverity: [Int: Int] = [:]
    var hamdFrequency: [Int: Int] = [:]
    var hamdScore: [Int: Int] = [:]

    // MARK: - MFES (0-10)
    var mfesAnswers: [Int: Int] = [:]

    // MARK: - mGES (1-10)
    var mgesAnswers: [Int: Int] = [:]

    // MARK: - PDSS-2
    var pdss2Answers: [Int: Int] = [:]

    // MARK: - WOQ-9
    var woq9S1: [Int: Bool] = [:]
    var woq9S2: [Int: Bool] = [:]

    // MARK: - Progress (0.0-1.0)
    var aaeProgress:   Double { Double(aaeTouched.count) / 60.0 }
    var bisbasProgress: Double { Double(bisbasAnswers.count) / 20.0 }
    var fogqProgress:  Double { Double(fogqAnswers.count) / 6.0 }
    var hamdProgress:  Double { Double(hamdScore.count) / 17.0 }
    var mfesProgress:  Double { Double(mfesAnswers.count) / 14.0 }
    var mgesProgress:  Double { Double(mgesAnswers.count) / 10.0 }
    var pdss2Progress: Double { Double(pdss2Answers.count) / 15.0 }
    var woq9Progress:  Double { Double(woq9S1.count) / 9.0 }

    // MARK: - Scores

    var aaeScore: (posAvg: Double, negAvg: Double, totalAvg: Double) {
        let pos = aaeItems.filter { $0.valence == .positive }.map { aaeValues[$0.id] ?? 50.0 }
        let neg = aaeItems.filter { $0.valence == .negative }.map { aaeValues[$0.id] ?? 50.0 }
        let negR = neg.map { 100.0 - $0 }
        func avg(_ a: [Double]) -> Double { a.isEmpty ? 0 : a.reduce(0,+)/Double(a.count) }
        return (round(avg(pos)*10)/10, round(avg(neg)*10)/10, round(avg(pos+negR)*10)/10)
    }

    var bisbasScore: (bis: Int, drive: Int, funSeeking: Int, rr: Int) {
        var bis=0, drive=0, fs=0, rr=0
        for item in bisbasItems {
            guard let raw = bisbasAnswers[item.id] else { continue }
            let s = item.reversed ? (5-raw) : raw
            switch item.subscale {
            case .BIS:                  bis  += s
            case .Drive:               drive += s
            case .FunSeeking:          fs    += s
            case .RewardResponsiveness: rr   += s
            }
        }
        return (bis, drive, fs, rr)
    }

    var fogqTotal: Int { fogqAnswers.values.reduce(0,+) }
    var hamdTotal: Int { hamdScore.values.reduce(0,+) }

    var hamdSeverityLabel: String {
        let t = hamdTotal
        if t <= 7  { return "正常（0〜7）" }
        if t <= 13 { return "軽度（8〜13）" }
        if t <= 18 { return "中等度（14〜18）" }
        if t <= 22 { return "重度（19〜22）" }
        return "最重度（23以上）"
    }

    var mfesTotal: Int { mfesAnswers.values.reduce(0,+) }
    var mgesTotal: Int { mgesAnswers.values.reduce(0,+) }
    var pdss2Total: Int { pdss2Answers.values.reduce(0,+) }

    var woqResult: (s1: Int, s2: Int, positive: Bool) {
        let s1 = woq9S1.values.filter { $0 }.count
        let s2 = woq9S2.values.filter { $0 }.count
        return (s1, s2, s2 >= 1)
    }

    // MARK: - HAMD score update

    func updateHAMDScore(itemID: Int) {
        guard let item = hamdItems.first(where: { $0.id == itemID }) else { return }
        guard let sev = hamdSeverity[itemID] else { hamdScore.removeValue(forKey: itemID); return }
        switch item.type {
        case .solo:
            if let scores = item.soloScores, sev < scores.count {
                hamdScore[itemID] = scores[sev]
            }
        case .grid:
            if sev == 0 {
                hamdScore[itemID] = 0
            } else if let freq = hamdFrequency[itemID],
                      let grid = item.grid,
                      sev < grid.count, freq < grid[sev].count {
                hamdScore[itemID] = grid[sev][freq]
            } else {
                hamdScore.removeValue(forKey: itemID)
            }
        }
    }

    // MARK: - CSV Export

    func csvFileURL() -> URL {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyyMMdd"
        let id  = participantID.isEmpty ? "unknown" : participantID
        let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent("questionnaire_\(id)_\(fmt.string(from: evaluationDate)).csv")
        try? buildCSV().write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    private func buildCSV() -> String {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
        let aae = aaeScore; let bb = bisbasScore; let wq = woqResult
        var L: [String] = [
            "統合質問紙 結果レポート",
            "被験者ID,\(participantID)", "評価日,\(fmt.string(from: evaluationDate))", "",
            "=== サマリー ===", "スコア名,値,最大値",
            "AAE_ポジティブ平均,\(aae.posAvg),100",
            "AAE_ネガティブ平均,\(aae.negAvg),100",
            "AAE_総合スコア,\(aae.totalAvg),100",
            "BIS,\(bb.bis),28","BAS-Drive,\(bb.drive),16",
            "BAS-FunSeeking,\(bb.funSeeking),16","BAS-報酬反応性,\(bb.rr),20",
            "FOG-Q合計,\(fogqTotal),24",
            "HAMD-17合計,\(hamdTotal),52","HAMD-17重症度,\(hamdSeverityLabel),",
            "MFES合計,\(mfesTotal),140","mGES合計,\(mgesTotal),100","PDSS-2合計,\(pdss2Total),60",
            "WOQ9_Step1,\(wq.s1),9","WOQ9_Step2,\(wq.s2),9",
            "WOQ9_判定,\(wq.positive ? "陽性":"陰性"),","",
            "=== AAE ===","番号,語,感情価,生値,集計値"
        ]
        for item in aaeItems {
            let raw = aaeValues[item.id] ?? 50.0
            let calc: String
            switch item.valence {
            case .positive: calc="\(raw)"; case .negative: calc="\(100.0-raw)"; case .neutral: calc=""
            }
            let v = item.valence == .positive ? "P" : item.valence == .negative ? "N" : "NEU"
            L.append("\(item.id),\(item.word),\(v),\(raw),\(calc)")
        }
        L += ["","=== BIS/BAS ===","番号,尺度,逆転,選択,得点"]
        for item in bisbasItems {
            let raw = bisbasAnswers[item.id]; let rawS = raw.map(String.init) ?? ""
            let sc  = raw.map { item.reversed ? (5-$0) : $0 }.map(String.init) ?? ""
            let sub: String
            switch item.subscale {
            case .BIS: sub="BIS"; case .Drive: sub="Drive"
            case .FunSeeking: sub="FS"; case .RewardResponsiveness: sub="RR"
            }
            L.append("\(item.id),\(sub),\(item.reversed ? "○":""),\(rawS),\(sc)")
        }
        L += ["","=== FOG-Q ===","番号,得点"]
        fogqItems.forEach { L.append("\($0.id),\(fogqAnswers[$0.id].map(String.init) ?? "")") }
        L += ["","=== HAMD-17 ===","番号,項目名,タイプ,程度,頻度,得点"]
        for item in hamdItems {
            L.append("\(item.id),\(item.name),\(item.type == .grid ? "G":"S")," +
                     "\(hamdSeverity[item.id].map(String.init) ?? "")," +
                     "\(item.type == .grid ? (hamdFrequency[item.id].map(String.init) ?? "") : "")," +
                     "\(hamdScore[item.id].map(String.init) ?? "")")
        }
        L += ["","=== MFES ===","番号,得点"]
        mfesItems.enumerated().forEach { i,_ in L.append("\(i+1),\(mfesAnswers[i+1].map(String.init) ?? "")") }
        L += ["","=== mGES ===","番号,得点"]
        mgesItems.enumerated().forEach { i,_ in L.append("\(i+1),\(mgesAnswers[i+1].map(String.init) ?? "")") }
        L += ["","=== PDSS-2 ===","番号,逆転,得点"]
        pdss2Items.forEach { L.append("\($0.id),\($0.reversed ? "○":""),\(pdss2Answers[$0.id].map(String.init) ?? "")") }
        L += ["","=== WOQ-9 ===","番号,症状,Step1,Step2"]
        for (i, sym) in woq9Symptoms.enumerated() {
            let id = i+1
            let s1: String = woq9S1[id].map { $0 ? "1":"0" } ?? ""
            let s2: String = (woq9S1[id] == true) ? (woq9S2[id].map { $0 ? "1":"0" } ?? "") : ""
            L.append("\(id),\(sym),\(s1),\(s2)")
        }
        return L.joined(separator: "\n")
    }
}
