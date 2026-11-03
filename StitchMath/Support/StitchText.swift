import Foundation

/// 界面上出现的每一句英文都从这里取。
enum StitchText {
    static let appName = "Stitch Math"

    // 向导
    static let stepGauge = "Gauge"
    static let stepSize = "Size"
    static let stepYarn = "Yarn"
    static let stepResult = "Result"
    static let back = "Back"
    static let next = "Next"
    static let seeResult = "See result"
    static let startOver = "Start over"
    static let save = "Save"
    static let cancel = "Cancel"
    static let done = "Done"

    static func stepCounter(_ index: Int) -> String {
        "Step \(index) of 4"
    }

    // 第一步：密度
    static let gaugeIntro = "Count a washed and dried swatch — not one straight off the needles. Everything else is worked out from these two numbers."
    static let swatchMeasuredOver = "Measured over"
    static let swatchTenCm = "10 cm"
    static let swatchFourInches = "4 in"
    static let stitchesLabel = "Stitches"
    static let rowsLabel = "Rows"
    static let densitySection = "Density"
    static let densityStitches = "stitches per 10 cm"
    static let densityRows = "rows per 10 cm"
    static let densityWarning = "Enter a count above zero."
    static let gaugeTipTitle = "Getting a usable count"
    static let gaugeTip = "Lay the swatch flat without stretching it, put a pin in at 0, count whole stitches to the mark. Half a stitch at the end counts as half."

    // 第二步：尺寸
    static let sizeIntro = "Finished measurements of the piece itself, not the body it is for."
    static let widthLabel = "Width"
    static let heightLabel = "Height"
    static let patternSection = "Pattern repeat"
    static let repeatStitchesLabel = "Stitches in one repeat"
    static let repeatOffsetLabel = "Edge stitches"
    static let repeatExplain = "A repeat of 8 with 2 edge stitches means multiples of 8, plus 2. Leave it at 1 if the pattern has no repeat."
    static let straightCastOn = "Straight from the gauge"
    static let alignedCastOn = "Rounded for the repeat"
    static let addedStitches = "added"

    // 第三步：线
    static let yarnIntro = "Choose the weight, then correct the length and grams against your own ball band — they differ between brands."
    static let weightLabel = "Yarn weight"
    static let skeinSection = "One skein"
    static let skeinLength = "Length"
    static let skeinGrams = "Weight"
    static let safetySection = "Buy extra"
    static let safetyNote = "Cables, lace and ribbing use more yarn than plain stockinette. Ten percent is a sane default."
    static let estimatedYarn = "Estimated yarn"
    static let typicalDensity = "usually knits at"

    // 结果
    static let castOnLabel = "Cast on"
    static let rowsLabelResult = "Knit"
    static let yarnNeededLabel = "Yarn needed"
    static let buyLabel = "Buy"
    static let stitchesUnit = "stitches"
    static let rowsUnit = "rows"
    static let skeinsUnit = "skeins"
    static let totalWeight = "total"
    static let saveSection = "Keep this plan"
    static let namePlaceholder = "Name it (Winter scarf)"
    static let saveExplain = "Saved plans live on this device only."

    // 作品库
    static let libraryTitle = "Saved plans"
    static let libraryEmpty = "Nothing saved yet."
    static let librarySwipeHint = "Swipe a row to delete it."

    // 关于 / 设置
    static let infoTitle = "About"
    static let informationSection = "What this does"
    static let informationBody = "Stitch Math turns a gauge swatch into the numbers you actually cast on: stitches across, rows up, yarn in metres and skeins to buy. Nothing is guessed from a size chart."
    static let methodSection = "Where the yarn figure comes from"
    static let methodBody = "Yarn length is estimated from the number of stitches worked and the size of each stitch, then scaled by the safety margin you chose. It is a planning figure: swatch again if your yarn is very fuzzy or your tension is loose."
    static let privacySection = "Privacy"
    static let privacyBody = "No account, no network, no analytics. Saved plans are written to a file inside the app on this device and deleted with the app."
    static let disclaimerSection = "Limits"
    static let disclaimerBody = "The density you enter is the density you get. Measurements, blocking and yarn substitution all move the result, so treat every number here as a starting point."
    static let settingsSection = "Settings"
    static let unitsLabel = "Units"
    static let showGramsLabel = "Show total weight"
    static let densityHintLabel = "Repeat the density on the result"
    static let versionLine = "Version 1.0"
}
