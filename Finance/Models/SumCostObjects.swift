import RealmSwift
import Foundation

final class SumCostDayModel: Object{
    @Persisted(primaryKey: true) var costId: String
    @Persisted var dayValue: Int
    @Persisted var monthValue: Int
    @Persisted var yearValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<Categories.RawValue, Int>
    
    convenience init(costId: String, dayValue: Int, monthValue: Int, yearValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.costId = costId
        self.dayValue = dayValue
        self.monthValue = monthValue
        self.yearValue = yearValue
        self.keyValue = keyValue
        for category in Categories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }
}

final class SumCostMonthModel: Object{
    @Persisted(primaryKey: true) var costId: String
    @Persisted var yearValue: Int
    @Persisted var monthValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<Categories.RawValue, Int>
    
    convenience init(costId: String, yearValue: Int, monthValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.costId = costId
        self.yearValue = yearValue
        self.monthValue = monthValue
        self.keyValue = keyValue
        for category in Categories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }
}
final class SumCostYearModel: Object{
    @Persisted(primaryKey: true) var costId: String
    @Persisted var yearValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<Categories.RawValue, Int>
    
    convenience init(costId: String, yearValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.costId = costId
        self.yearValue = yearValue
        self.keyValue = keyValue
        for category in Categories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }

}
