import Foundation
import RealmSwift

final class StorageService{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object)
        }
    }
    
    func fetchObjectsByMonth(month: Int, year: Int) -> [CostRealm] {
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).filter("monthValue = \(month)").filter("yearValue = \(year)").toArray()
    }
    
    func fecthObjectsMonth(month: Int, year: Int){
        guard let storage else { return  }
        var monthObjects = storage.objects(CostRealm.self).filter("monthValue = \(month)").filter("yearValue = \(year)").toArray()
        
    }
    
    func fetchObjectByYear(year: Int) -> [CostRealm]{
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).filter("yearValue = \(year)").toArray()
    }
    
    func fetchAll() -> [CostRealm]{
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).toArray().reversed()
    }
    
    func fetchByDate(day: Int, month: Int, year: Int) -> [CostRealm]{
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).filter("dayValue = \(day)").filter("monthValue = \(month)").filter("yearValue = \(year)").toArray()
    }
    
    func fetchSumAllTime() -> Int{
        guard let storage else { return 0 }
        return storage.objects(CostRealm.self).sum(ofProperty:"sumCost")
    }
    
    func fetchSumByDate(day: Int, month: Int, year: Int) -> Int{
        guard let storage else { return 0 }
        return storage.objects(CostRealm.self).filter("dayValue = \(day)").filter("monthValue = \(month)").filter("yearValue = \(year)").sum(ofProperty: "sumCost")
    }
    
    func fetchSumCurrentDay() -> Int{
        guard let storage else { return 0 }
        print(Date())
        return storage.objects(CostRealm.self).filter("dayValue = \(Calendar.current.component(.day, from: Date()))").filter("monthValue = \(Calendar.current.component(.month, from: Date()))").filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumCost")
        
        
    }
    
    func fetchSumCurrentMonth() -> Int{
        guard let storage else { return 0 }
        return storage.objects(CostRealm.self).filter("monthValue = \(Calendar.current.component(.month, from: Date()))").filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumCost")
    }
    
    func fetchSumCurrentYear() -> Int{
        guard let storage else { return 0 }
        return storage.objects(CostRealm.self).filter("yearValue = \(Calendar.current.component(.year, from: Date()))").sum(ofProperty: "sumCost")
    }
    

    func fetchAllDates() -> [Date]{
        guard let storage else { return [] }
        var arrayDates: [Date] = []
        let array = storage.objects(CostRealm.self).toArray()
        for item in array{
            var dateComponents = DateComponents()
            dateComponents.day = Calendar.current.component(.day, from: item.date)
            dateComponents.month = Calendar.current.component(.month, from: item.date)
            dateComponents.year = Calendar.current.component(.year, from: item.date)

            arrayDates.append(Calendar.current.date(from: dateComponents)!)
        }
        return Array(Set(arrayDates))
    }
    
    //Функция получения данных интервала
    
}
extension Results{
    func toArray() -> [Element]{
        .init(self)
    }
}
