import Foundation

// MARK: - AAE

enum AAEValence: String {
    case positive, negative, neutral
}

struct AAEItem: Identifiable {
    let id: Int
    let word: String
    let valence: AAEValence
    let leftLabel: String
    let rightLabel: String
}

// MARK: - BIS/BAS

enum BISBASSubscale {
    case BIS, Drive, FunSeeking, RewardResponsiveness
}

struct BISBASSection: Identifiable {
    let id = UUID()
    let label: String
    let itemIDs: [Int]
}

struct BISBASItem: Identifiable {
    let id: Int
    let text: String
    let subscale: BISBASSubscale
    let reversed: Bool
}

// MARK: - FOG-Q

struct FOGQItem: Identifiable {
    let id: Int
    let text: String
    let options: [String]
}

// MARK: - HAMD

enum HAMDType { case grid, solo }

struct HAMDItem: Identifiable {
    let id: Int
    let name: String
    let note: String
    let type: HAMDType
    let severityOptions: [String]
    let grid: [[Int]]?
    let soloScores: [Int]?
}

let hamdFrequencyOptions = [
    "なし（0日）",
    "ときどき（週1〜2日）",
    "しばしば（週3〜5日）",
    "ほとんど毎日（週6〜7日）"
]

// MARK: - PDSS-2

struct PDSS2Item: Identifiable {
    let id: Int
    let text: String
    let reversed: Bool
}

let pdss2OptionsNormal: [(label: String, score: Int)] = [
    ("とても多い（週6〜7日）", 4),
    ("多い（週4〜5日）", 3),
    ("ときどき（週2〜3日）", 2),
    ("ほとんどない（週1日）", 1),
    ("全くない", 0)
]

let pdss2OptionsReversed: [(label: String, score: Int)] = [
    ("とても多い（週6〜7日）", 0),
    ("多い（週4〜5日）", 1),
    ("ときどき（週2〜3日）", 2),
    ("ほとんどない（週1日）", 3),
    ("全くない", 4)
]
