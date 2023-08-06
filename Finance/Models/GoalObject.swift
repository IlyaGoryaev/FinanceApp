import RealmSwift
import Foundation

final class GoalObject: Object{
    
    @Persisted(primaryKey: true) var costId: String
    @Persisted var goalSum: Int
    @Persisted var currentSum: Int
    @Persisted var picture: String
    
    convenience init(costId: String, goalSum: Int, currentSum: Int, picture: String) {
        self.init()
        self.costId = costId
        self.goalSum = goalSum
        self.currentSum = currentSum
        self.picture = picture
    }
}
