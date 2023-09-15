import Foundation

class CostByPeriod{
    
    static let get = CostByPeriod()
    
    private let storage = CostStorageService()
    
    func currentDay() -> [CostRealm]{
        let dayComponents = CurrentDateComponents.get.day()
        var costArray = storage.fetchByDate(day: dayComponents.day!, month: dayComponents.month!, year: dayComponents.year!)
        costArray = costArray.sorted { cost1, cost2 in
            cost1.date >= cost2.date
        }
        return costArray
    }
    
    func currentMonth() -> [Date : [CostRealm]]{
        var costsArray: [Date : [CostRealm]] = [:]
        let dates = DatesByPeriod.get.monthDates()
        
        for date in dates {
            var costsArrayByDate = storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date))
            if !costsArrayByDate.isEmpty{
                costsArrayByDate = costsArrayByDate.sorted(by: { item1, item2 in
                    item1.date > item2
                    .date                })
                costsArray[date] = costsArrayByDate
            }
        }
        
        return costsArray
    }
    
    func currentWeek() -> [Date : [CostRealm]]{
        var costsArray: [Date : [CostRealm]] = [:]
        let dates = DatesByPeriod.get.weekDates()
        
        for date in dates {
            var costsArrayByDate = storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date))
            if !costsArrayByDate.isEmpty{
                costsArrayByDate = costsArrayByDate.sorted(by: { item1, item2 in
                    item1.date > item2.date
                })
                costsArray[date] = costsArrayByDate
            }
        }
        
        return costsArray
    }
    
}
