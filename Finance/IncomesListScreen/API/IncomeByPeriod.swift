import Foundation

class IncomeByPeriod{
    
    static let get = IncomeByPeriod()
    
    private let storage = IncomeStorageService()
    
    func currentDay() -> [IncomeRealm]{
        let dayComponents = CurrentDateComponents.get.day()
        var incomeArray = storage.fetchByDate(day: dayComponents.day!,
                                              month: dayComponents.month!,
                                              year: dayComponents.year!)
        incomeArray = incomeArray.sorted { income1, income2 in
            income1.date >= income2.date
        }
        return incomeArray
    }
    
    func currentMonth() -> [Date : [IncomeRealm]]{
        var incomeArray: [Date : [IncomeRealm]] = [:]
        let dates = DatesByPeriod.get.monthDates()
        for date in dates {
            var incomeArrayByDate = storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date))
            if !incomeArrayByDate.isEmpty{
                incomeArrayByDate = incomeArrayByDate.sorted(by: { item1, item2 in
                    item1.date > item2
                    .date                })
                incomeArray[date] = incomeArrayByDate
            }
        }
        return incomeArray
    }
    
    func currentWeek() -> [Date : [IncomeRealm]]{
        var incomeArray: [Date : [IncomeRealm]] = [:]
        let dates = DatesByPeriod.get.weekDates()
        for date in dates {
            var incomeArrayByDate = storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date))
            if !incomeArrayByDate.isEmpty{
                incomeArrayByDate = incomeArrayByDate.sorted(by: { item1, item2 in
                    item1.date > item2.date
                })
                incomeArray[date] = incomeArrayByDate
            }
        }
        return incomeArray
    }
}

