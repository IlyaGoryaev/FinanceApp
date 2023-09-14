import Foundation

struct CostScreenModel: Identifiable{
    let id: Int
    let costPeriod: CostPeriod
    let sumCost: Int
    let categories: [String: Double]
    
    init(id: Int = 1, costPeriod: CostPeriod = .Day, sumCost: Int = 0, categories: [String : Double] = [:]) {
        self.id = id
        self.costPeriod = costPeriod
        self.sumCost = sumCost
        self.categories = categories
    }
}

enum CostPeriod: String{
    case Day
    case Month
    case Year
}
