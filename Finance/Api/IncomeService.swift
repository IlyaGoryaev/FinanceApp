import RealmSwift
import Foundation

class IncomeStorageService{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object, update: .all)
        }
    }
    
    func fetchObjectsByMonth(month: Int, year: Int) -> [IncomeRealm] {
        guard let storage else { return [] }
        return storage.objects(IncomeRealm.self).filter("monthValue = \(month)").filter("yearValue = \(year)").toArray()
    }
    
    func fetchObjectByYear(year: Int) -> [IncomeRealm]{
        guard let storage else { return [] }
        return storage.objects(IncomeRealm.self).filter("yearValue = \(year)").toArray()
    }
    
    func fetchByDate(day: Int, month: Int, year: Int) -> [IncomeRealm]{
        guard let storage else { return [] }
        return storage.objects(IncomeRealm.self).filter("dayValue = \(day)").filter("monthValue = \(month)").filter("yearValue = \(year)").toArray()
    }
    
    func fetchSumByDate(day: Int, month: Int, year: Int) -> Int{
        guard let storage else { return 0 }
        return storage.objects(IncomeRealm.self).filter("dayValue = \(day)").filter("monthValue = \(month)").filter("yearValue = \(year)").sum(ofProperty: "sumIncome")
    }
    
    func fetchSumCurrentDay() -> Int{
        guard let storage else { return 0 }
        return storage.objects(IncomeRealm.self).filter("dayValue = \(Calendar.current.component(.day, from: Date()))").filter("monthValue = \(Calendar.current.component(.month, from: Date()))").filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumIncome")
    }
    
    func fetchSumCurrentMonth() -> Int{
        guard let storage else { return 0 }
        return storage.objects(IncomeRealm.self).filter("monthValue = \(Calendar.current.component(.month, from: Date()))").filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumIncome")
    }
    
    func fetchSumCurrentYear() -> Int{
        guard let storage else { return 0 }
        return storage.objects(IncomeRealm.self).filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumIncome")
    }
    
    func fetchAllDates() -> [Date]{
        guard let storage else { return [] }
        var arrayDates: [Date] = []
        let array = storage.objects(IncomeRealm.self).toArray()
        for item in array{
            var dateComponents = DateComponents()
            dateComponents.day = Calendar.current.component(.day, from: item.date)
            dateComponents.month = Calendar.current.component(.month, from: item.date)
            dateComponents.year = Calendar.current.component(.year, from: item.date)

            arrayDates.append(Calendar.current.date(from: dateComponents)!)
        }
        return Array(Set(arrayDates))
    }
}
