import Foundation
import RealmSwift

final class IncomeRealm: Object{
    @Persisted(primaryKey: true) var incomeId: String
    @Persisted var dayValue: Int
    @Persisted var monthValue: Int
    @Persisted var yearValue: Int
    @Persisted var sumIncome: Int
    @Persisted var label: String
    @Persisted var date: Date
    @Persisted var category: IncomeCategories.RawValue
    
    
    convenience init(incomeId: String,
                     date: Date,
                     sumIncome: Int,
                     label: String,
                     category: Categories.RawValue
    ) {
        self.init()
        self.incomeId = incomeId
        self.date = date
        //Тестирование дат
        self.dayValue = Calendar.current.component(.day, from: date)
        self.monthValue = Calendar.current.component(.month, from: date)
        self.yearValue = Calendar.current.component(.year, from: date)
        self.sumIncome = sumIncome
        self.label = label
        self.category = category
    }
}
