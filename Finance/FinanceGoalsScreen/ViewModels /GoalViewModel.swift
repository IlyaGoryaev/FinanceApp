import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class GoalViewModel{
    
    var items = BehaviorSubject(value: [SectionModel(model: "", items: [GoalObject]())])
        
    func fetchGoals(){
        let storage = GoalsService()
        let array = storage.getAllGoalModels()
        
        items.on(.next([SectionModel(model: "", items: array)]))
    }
    
}
