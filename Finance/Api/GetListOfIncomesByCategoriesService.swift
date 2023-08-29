import RealmSwift
import Foundation

class GetListOfIncomesByCategoriesService{
    
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func getListCategoryByDay(date: Date, category: String) -> [IncomeRealm]{
        guard let storage else { return [] }
        return storage.objects(IncomeRealm.self).filter("dayValue = \(Calendar.current.component(.day, from: date))").filter("monthValue = \(Calendar.current.component(.month, from: date))").filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { income1, income2 in
            income1.sumIncome > income2.sumIncome
        }
    }
    
    func getListCategoryByMonth(date: Date, category: String) -> [IncomeRealm]{
        guard let storage else { return [] }
        print(category)
        return storage.objects(IncomeRealm.self).filter("monthValue = \(Calendar.current.component(.month, from: date))").filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { income1, income2 in
            income1.sumIncome > income2.sumIncome
        }
    }
    
    func getListCategoryByYear(date: Date, category: String) -> [IncomeRealm]{
        guard let storage else { return [] }
        return storage.objects(IncomeRealm.self).filter("yearValue = \(Calendar.current.component(.year, from: date))").where {
            $0.category == category
        }.toArray().sorted { income1, income2 in
            income1.sumIncome > income2.sumIncome
        }
    }
    
}
