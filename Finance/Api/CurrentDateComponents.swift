import Foundation

final class CurrentDateComponents{
    
    static let get = CurrentDateComponents()
    
    func day() -> DateComponents{
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        return dateComponents
    }
    
    func month() -> DateComponents{
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        return dateComponents
    }
    
    func year() -> DateComponents{
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.year = Calendar.current.component(.year, from: Date())
        return dateComponents
    }
}
