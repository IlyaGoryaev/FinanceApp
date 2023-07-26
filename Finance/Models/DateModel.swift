import Foundation
import RealmSwift

final class DateObject: Object{
    
    @Persisted(primaryKey: true) var dateId: String
    @Persisted var date: Date
    
    convenience init(dateId: String, date: Date) {
        self.init()
        self.dateId = dateId
        self.date = date
    }
}
