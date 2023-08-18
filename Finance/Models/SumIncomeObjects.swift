import RealmSwift
import Foundation

final class SumIncomeDayModel: Object{
    @Persisted(primaryKey: true) var incomeId: String
    @Persisted var dayValue: Int
    @Persisted var monthValue: Int
    @Persisted var yearValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<IncomeCategories.RawValue, Int>
    
    convenience init(incomeId: String, dayValue: Int, monthValue: Int, yearValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.incomeId = incomeId
        self.dayValue = dayValue
        self.monthValue = monthValue
        self.yearValue = yearValue
        self.keyValue = keyValue
        for category in IncomeCategories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }
}

final class SumIncomeMonthModel: Object{
    @Persisted(primaryKey: true) var incomeId: String
    @Persisted var yearValue: Int
    @Persisted var monthValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<IncomeCategories.RawValue, Int>
    
    convenience init(incomeId: String, yearValue: Int, monthValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.incomeId = incomeId
        self.yearValue = yearValue
        self.monthValue = monthValue
        self.keyValue = keyValue
        for category in IncomeCategories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }
}
final class SumIncomeYearModel: Object{
    @Persisted(primaryKey: true) var incomeId: String
    @Persisted var yearValue: Int
    @Persisted var keyValue: DateComponentsForModel.RawValue
    @Persisted var dictOfSumByCategories: Map<IncomeCategories.RawValue, Int>
    
    convenience init(incomeId: String, yearValue: Int, keyValue: DateComponentsForModel.RawValue) {
        self.init()
        self.incomeId = incomeId
        self.yearValue = yearValue
        self.keyValue = keyValue
        for category in IncomeCategories.allCases{
            dictOfSumByCategories[category.rawValue] = 0
        }
    }

}

