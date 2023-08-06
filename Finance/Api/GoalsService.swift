import RealmSwift
import Foundation


class GoalsService{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func saveNewModel(object: Object) throws{
        guard let storage else { return }
        try storage.write({
            storage.add(object, update: .all)
        })
    }
    
    func getGoalModel(name: String) -> [GoalObject]{
        guard let storage else { return [] }
        return storage.objects(GoalObject.self).where {
            $0.costId == name
        }.toArray()
    }
    
    func getAllGoalModels() -> [GoalObject]{
        guard let storage else { return [] }
        return storage.objects(GoalObject.self).toArray()
    }
}
