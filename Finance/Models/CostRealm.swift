import Foundation
import RealmSwift

final class CostRealm: Object{
    @Persisted(primaryKey: true) var costId: String
    @Persisted var dayValue: Int
    @Persisted var monthValue: Int
    @Persisted var yearValue: Int
    @Persisted var sumCost: Int
    @Persisted var label: String
    @Persisted var date: Date
    @Persisted var category: Categories.RawValue
    
    convenience init(costId: String,
                     date: Date,
                     sumCost: Int,
                     label: String,
                     category: Categories.RawValue
    ) {
        self.init()
        self.costId = costId
        self.date = date
        self.dayValue = Calendar.current.component(.day, from: date)
        self.monthValue = Calendar.current.component(.month, from: date)
        self.yearValue = Calendar.current.component(.year, from: date)
        self.sumCost = sumCost
        self.label = label
        self.category = category
    }
    
}
