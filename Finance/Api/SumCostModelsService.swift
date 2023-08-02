import RealmSwift
import Foundation

class SumCostModelsService{
    
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
    
    func getDayObjectForKey(day: Int, month: Int, year: Int) -> [SumCostDayModel]{
        guard let storage else { return [] }
        return storage.objects(SumCostDayModel.self).where({
            $0.dayValue == day && $0.monthValue == month && $0.yearValue == year
        }).toArray()
    }
    
    func getMonthObjectForKey(month: Int, year: Int) -> [SumCostMonthModel]{
        guard let storage else { return [] }
        return storage.objects(SumCostMonthModel.self).where {
            $0.monthValue == month && $0.yearValue == year
        }.toArray()
    }
    
    func getYearObjectForKey(year: Int) -> [SumCostYearModel]{
        guard let storage else { return [] }
        return storage.objects(SumCostYearModel.self).where {
            $0.yearValue == year
        }.toArray()
    }
    
    
    
}
