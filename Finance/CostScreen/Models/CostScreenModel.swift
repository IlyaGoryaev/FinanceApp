import Foundation

struct CostScreenModel{
    
    let period: Period
    let date: Date
    let sumCost: Int
    let categories: [CostCategoryModel]
    
    init(date: Date = Date() ,costPeriod: Period = .Day, sumCost: Int = 0, categories: [CostCategoryModel] = []) {
        self.date = date
        self.period = costPeriod
        self.sumCost = sumCost
        self.categories = categories
    }
}

enum Period: String{
    case Day
    case Month
    case Year
}
