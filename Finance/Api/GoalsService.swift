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
    
    func getDictGoalObjects() -> [String: String]{
        guard let storage else { return [:] }
        var dictGoalObjects: [String: String] = [:]
        let objects = storage.objects(GoalObject.self).toArray()
        for object in objects {
            dictGoalObjects[object.costId] = object.picture
        }
        return dictGoalObjects
    }
    
    func getGoalModel(name: String) -> [GoalObject]{
        guard let storage else { return [] }
        return storage.objects(GoalObject.self).where {
            $0.costId == name
        }.toArray()
    }
    
    func getGoalModelByPicture(picture: String) -> [GoalObject]{
        guard let storage else { return [] }
        return storage.objects(GoalObject.self).where {
            $0.picture == picture
        }.toArray()
    }
    
    func getAllGoalModels() -> [GoalObject]{
        guard let storage else { return [] }
        return storage.objects(GoalObject.self).toArray()
    }
}
