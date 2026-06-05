import Foundation

enum Language: String {
    case chinese = "zh"
    case english = "en"
}

final class LanguageManager {

    static let shared = LanguageManager()
    static let changedNotification = Notification.Name("LanguageChanged")

    private let key = "AppLanguage"

    var current: Language {
        get {
            if let raw = UserDefaults.standard.string(forKey: key),
               let lang = Language(rawValue: raw) {
                return lang
            }
            return .chinese
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
            NotificationCenter.default.post(name: Self.changedNotification, object: nil)
        }
    }

    private init() {}

    func text(_ chinese: String, _ english: String) -> String {
        current == .chinese ? chinese : english
    }
}
