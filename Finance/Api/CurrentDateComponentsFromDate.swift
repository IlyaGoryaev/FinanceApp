import Foundation

final class CurrentDateComponentsFromDate{
    
    static let get = CurrentDateComponentsFromDate()
    
    func components(date: Date) -> DateComponents{
        var dateComponents = DateComponents()
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.locale = .current
        dateComponents.timeZone = .current
        dateComponents.calendar = .current
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.year = calendar.component(.year, from: date)
        return dateComponents
    }
    
}
