import SwiftUI
// https://github.com/sallar/github-contributions-canvas/blob/master/src/themes.js

class GraphTheme: ObservableObject {
    @Published var selectedIndex: Int = 0

    private let allThemes: [IntensitiesTheme] = [
        Standard(),
        Halloween(),
        Teal(),
//        LeftPad(),
    ]

    func color(with intensity: Int) -> Color {
        return colors.color(with: intensity)
    }

    var colors: IntensitiesTheme {
        let index = max(min(allThemes.count - 1, selectedIndex), 0)
        return allThemes[index]
    }
}

protocol IntensitiesTheme {
    var id        : String { get }
    var background: Color { get }
    var text      : Color { get }
    var meta      : Color { get }
    var intensity0: Color { get }
    var intensity1: Color { get }
    var intensity2: Color { get }
    var intensity3: Color { get }
    var intensity4: Color { get }
}

extension IntensitiesTheme {

    var intensities: [Color] {
        return [intensity0, intensity1, intensity2, intensity3, intensity4]
    }

    func color(with intensity: Int) -> Color {
        switch intensity {
        case 0: return intensity0
        case 1: return intensity1
        case 2: return intensity2
        case 3: return intensity3
        case 4: return intensity4
        default: return intensity0
        }
    }
}

struct Standard: IntensitiesTheme, Identifiable {
    let id: String = "Standard"
    let background = Color(hex: "#ffffff")
    let text       = Color(hex: "#000000")
    let meta       = Color(hex: "#666666")
    let intensity0 = Color(hex: "#ebedf0")
    let intensity1 = Color(hex: "#c6e48b")
    let intensity2 = Color(hex: "#7bc96f")
    let intensity3 = Color(hex: "#239a3b")
    let intensity4 = Color(hex: "#196127")
}

struct Halloween: IntensitiesTheme {
    let id: String = "Halloween"
    let background = Color(hex: "#ffffff")
    let text       = Color(hex: "#000000")
    let meta       = Color(hex: "#666666")

    let intensity0 = Color(hex: "#EBEDF0")
    let intensity1 = Color(hex: "#FFEE4A")
    let intensity2 = Color(hex: "#FFC501")
    let intensity3 = Color(hex: "#FE9600")
    let intensity4 = Color(hex: "#03001C")
}

struct Teal: IntensitiesTheme {
    let id: String = "Teal"
    let background = Color(hex: "#ffffff")
    let text       = Color(hex: "#000000")
    let meta       = Color(hex: "#666666")

    let intensity0 = Color(hex: "#ebedf0")
    let intensity1 = Color(hex: "#7FFFD4")
    let intensity2 = Color(hex: "#76EEC6")
    let intensity3 = Color(hex: "#66CDAA")
    let intensity4 = Color(hex: "#458B74")
}

struct LeftPad: IntensitiesTheme {
    let id: String = "LeftPad"
    let background = Color(hex: "#000000")
    let text       = Color(hex: "#ffffff")
    let meta       = Color(hex: "#999999")

    let intensity0 = Color(hex: "#2F2F2F")
    let intensity1 = Color(hex: "#646464")
    let intensity2 = Color(hex: "#A5A5A5")
    let intensity3 = Color(hex: "#DDDDDD")
    let intensity4 = Color(hex: "#F6F6F6")
}
