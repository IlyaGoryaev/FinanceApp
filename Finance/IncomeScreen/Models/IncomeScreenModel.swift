import Foundation

struct IncomeScreenModel{
    
    let period: Period
    let date: Date
    let sumIncome: Int
    let categories: [IncomeCategoryModel]
    
    
    init(period: Period = .Day, date: Date = Date(), sumIncome: Int = 0, categories: [IncomeCategoryModel] = []) {
        self.period = period
        self.date = date
        self.sumIncome = sumIncome
        self.categories = categories
    }
    
}
