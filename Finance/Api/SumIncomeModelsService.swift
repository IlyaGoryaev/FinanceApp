import RealmSwift
import Foundation

class SumIncomeModelsService{
    
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func saveNewModel(object: Object) throws{
        guard let storage else { return }
        try storage.write({
            storage.add(object, update: .all)
        })
    }
    
    func getDayObjectForKey(day: Int, month: Int, year: Int) -> [SumIncomeDayModel]{
        guard let storage else { return [] }
        return storage.objects(SumIncomeDayModel.self).where({
            $0.dayValue == day && $0.monthValue == month && $0.yearValue == year
        }).toArray()
    }
    
    func getMonthObjectForKey(month: Int, year: Int) -> [SumIncomeMonthModel]{
        guard let storage else { return [] }
        return storage.objects(SumIncomeMonthModel.self).where {
            $0.monthValue == month && $0.yearValue == year
        }.toArray()
    }
    
    func getYearObjectForKey(year: Int) -> [SumIncomeYearModel]{
        guard let storage else { return [] }
        return storage.objects(SumIncomeYearModel.self).where {
            $0.yearValue == year
        }.toArray()
    }
}
