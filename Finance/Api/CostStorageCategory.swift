import Foundation
import RealmSwift

final class CostStorageCategory{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    //Generic
    func getFoodCategories() -> Double{
        guard let storage else { return 0 }
        let sumAll: Double = storage.objects(CostRealm.self).sum(ofProperty: "sumCost")
        let foodPersent: Double = storage.objects(CostRealm.self).filter("category = 'food'").sum(ofProperty: "sumCost")
        return foodPersent / sumAll * 100
    }
    
    func getAutoCategories() -> Double{
        guard let storage else { return 0 }
        let sumAll: Double = storage.objects(CostRealm.self).sum(ofProperty: "sumCost")
        let foodPersent: Double = storage.objects(CostRealm.self).filter("category = 'auto'").sum(ofProperty: "sumCost")
        return foodPersent / sumAll * 100
    }
    
    
    func getAllValues() -> [Double]{
        return [getAutoCategories(), getFoodCategories()]
    }
}
