import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class ListSortedIncomesViewModel{
    
    var array = BehaviorSubject(value: [SectionModel(model: "", items: [IncomeRealm]())])
    
    func fetchData(category: String, periodId: Int){
        switch periodId{
        case 1:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByDay(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case 2:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByMonth(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        case 3:
            let array = GetListOfIncomesByCategoriesService().getListCategoryByYear(date: Date(), category: category)
            self.array.on(.next([SectionModel(model: "", items: array)]))
            break
        default:
            break
            
        }
    }
    
}
