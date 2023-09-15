import Foundation

class DatesByPeriod{
    
    static let get = DatesByPeriod()
    
    func monthDates() -> [Date]{
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        let monthRange = calendar.range(of: .day, in: .month, for: now)!
        let firstDay = calendar.dateComponents([.year, .month], from: now)
        var date = calendar.date(from: firstDay)!
        print(date)
        var dates: [Date] = []
        
        for _ in monthRange{
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }
    
    func weekDates() -> [Date]{
        let now = Date()
        var calendar = Calendar.current
        calendar.timeZone = .current
        calendar.firstWeekday = 2
        let weekRange = calendar.range(of: .day, in: .weekOfMonth, for: now)!
        var firstDay = calendar.dateComponents([.year, .month], from: now)
        firstDay.day = weekRange.lowerBound
        var date = calendar.date(from: firstDay)!
        var dates: [Date] = []

        for _ in 1...7{
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        print(dates)
        return dates
    }
    
}
