import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class CollectionViewModelView{
    
    var section = BehaviorSubject(value: [SectionModel(model: "", items: [CategoryModel]())])
    
    func fetchSections(){
        
        let storage = CostStorageCategory()
        print(storage.getAllValues())
        var categories: [CategoryModel] = []
        //переделать
        for i in 0...storage.getAllValues().count - 1{
            if i == 0{
                categories.append(CategoryModel(category: .auto, usage: Int(storage.getAllValues()[i])))
            } else {
                categories.append(CategoryModel(category: .food, usage: Int(storage.getAllValues()[i])))
            }

        }
        section.on(.next([SectionModel(model: "", items: categories)]))
        
        
    }
    
}
