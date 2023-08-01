import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

class AddCostViewModel{
    
    var categories = BehaviorSubject(value: [SectionModel(model: "", items: [AddCategoryModel]())])
    var date = BehaviorSubject(value: "433")//изменить на дату
    var cost = BehaviorSubject(value: CostRealm(costId: UUID().uuidString, date: Date(), sumCost: 0, label: "", category: "food"))
    var enabled = BehaviorSubject(value: false)
    var isCategorySelected = BehaviorSubject(value: false)
    var indexOfItemSelected = BehaviorSubject(value: -1)
    var sum = BehaviorSubject(value: 0)
    
    func fetchCategories(){
        let array: [AddCategoryModel] = [
            AddCategoryModel(category: .auto, color: .brown, image: UIImage(named: "auto")),
            AddCategoryModel(category: .food, color: .cyan, image: UIImage(named: "food")),
            AddCategoryModel(category: .health, color: .green, image: UIImage(named: "health")),
            AddCategoryModel(category: .houseRent, color: .magenta, image: UIImage(named: "houseRent")),
            AddCategoryModel(category: .householdExpenses, color: .orange, image: UIImage(named:"householdExpenses")),
            AddCategoryModel(category: .pets, color: .purple, image: UIImage(named: "pets")),
            AddCategoryModel(category: .sport, color: .red, image: UIImage(named: "sport")),
            AddCategoryModel(category: .transport, color: .systemMint, image: UIImage(named: "transport")),
            AddCategoryModel(category: .workExpenses, color: .gray, image: UIImage(named: "workExpenses"))]
        categories.on(.next( [SectionModel(model: "Категории", items: array)] ))
    }
    
    func newValuesForCost(sumCost: Int, category: Categories, label: String, date: Date){
        cost.on(.next(CostRealm(costId: UUID().uuidString, date: date, sumCost: sumCost, label: label, category: category.rawValue)))
    }
    
    func saveRealm(){
        let storage = StorageService()
        try! storage.saveOrUpdateObject(object: try! cost.value())
    }
    
    
    func sumAndCategoryChosen(){
        enabled.on(.next(true))
    }
    
    func categorySelect(isSelect: Bool){
        isCategorySelected.on(.next(isSelect))
    }
    
    func itemSelect(index: Int){
        indexOfItemSelected.on(.next(index))
    }
    
    func getSum(sum: Int){
        self.sum.on(.next(sum))
    }
    
}
