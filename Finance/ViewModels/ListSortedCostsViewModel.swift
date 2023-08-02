import RxSwift
import RxCocoa
import RxDataSources
import UIKit
//Реализовать период
class ListSortedCostsViewModel{
    
    var array = BehaviorSubject(value: [SectionModel(model: "", items: [CostRealm]())])
    
    func fetchData(category: String){
        let array = GetListOfCategoriesService().getListCategoryByYear(date: Date(), category: category)
        self.array.on(.next([SectionModel(model: "", items: array)]))
    }
    
}
