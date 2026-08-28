import SwiftUI

extension Color {
    static let chronoGold = Color(red: 0.56, green: 0.42, blue: 0.21)
    static let catalogBackground = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.09, green: 0.09, blue: 0.075, alpha: 1)
            : UIColor(red: 0.969, green: 0.961, blue: 0.937, alpha: 1)
    })
    static let cardBackground = Color(uiColor: .secondarySystemBackground)
    static let cardBorder = Color.primary.opacity(0.09)
}
