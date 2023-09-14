import Foundation
import UIKit
enum Theme: Int, CaseIterable{
    case system = 0
    case dark
    case light
}

extension Theme{
    
    @Persist(key: "app_theme", defaultValue: Theme.light.rawValue)
    private static var appTheme: Int
    
    // Сохранение темы в UserDefaults
    func save() {
        Theme.appTheme = self.rawValue
    }
    
    // Текущая тема приложения
    static var current: Theme {
        Theme(rawValue: appTheme) ?? .light
    }
    
}
extension Theme {
    
    @available(iOS 13.0, *)
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return themeWindow.traitCollection.userInterfaceStyle
        }
    }
    
    func setActive() {
        // Сохраняем активную тему
        save()
        
        guard #available(iOS 13.0, *) else { return }
        
        // Устанавливаем активную тему для всех окон приложения
        UIApplication.shared.windows
            .filter { $0 != themeWindow } 
            .forEach { $0.overrideUserInterfaceStyle = userInterfaceStyle }
    }
}


@propertyWrapper
struct Persist<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

extension UIWindow {
    
    // Устанавливаем текущую тему для окна
    // Необходимо вызывать перед показом окна
    func initTheme() {
        guard #available(iOS 13.0, *) else { return }
        
        overrideUserInterfaceStyle = Theme.current.userInterfaceStyle
    }
}
