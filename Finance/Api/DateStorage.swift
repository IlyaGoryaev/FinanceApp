import Foundation
import RealmSwift


final class DateStorage{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func saveOrUpdateObject(object: Object) throws {
        guard let storage else { return }
        try storage.write {
            storage.add(object)
        }
    }
    
    func fetchAll() -> [DateObject]{
        guard let storage else {
            return [] }
        return storage.objects(DateObject.self).toArray()
    }
    
    
}
