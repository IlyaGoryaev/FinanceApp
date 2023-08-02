import RealmSwift
import Foundation
class GetListOfCategoriesService{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func getListCategoryByDay(date: Date, category: String) -> [CostRealm]{
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).filter("dayValue = \(Calendar.current.component(.day, from: date))").filter("monthValue = \(Calendar.current.component(.month, from: date))").filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { cost1, cost2 in
            cost1.sumCost > cost2.sumCost
        }
    }
        
    func getListCategoryByMonth(date: Date, category: String) -> [CostRealm]{
        guard let storage else { return [] }
        print(category)
        return storage.objects(CostRealm.self).filter("monthValue = \(Calendar.current.component(.month, from: date))").filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { cost1, cost2 in
            cost1.sumCost > cost2.sumCost
        }
    }
    
    func getListCategoryByYear(date: Date, category: String) -> [CostRealm]{
        guard let storage else { return [] }
        return storage.objects(CostRealm.self).filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { cost1, cost2 in
            cost1.sumCost > cost2.sumCost
        }
    }
}
