import UIKit

class HapticFeedback {
    #if os(watchOS)
    /// watchOS implementation
    static func playSelection() -> Void {
        WKInterfaceDevice.current().play(.click)
    }
    #else
    /// iOS implementation
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    static func playSelection() -> Void {
        UISelectionFeedbackGenerator().selectionChanged()
    }
    #endif
}
