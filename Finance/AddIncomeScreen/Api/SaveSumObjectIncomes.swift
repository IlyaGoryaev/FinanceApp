import Foundation

class SaveSumObjectIncomes{
    
    static func saveSumObjectsIncome(dateComponents: DateComponents, category: String, sumIncome: Int){
        
        let storageSum = SumIncomeModelsService()
        
        //Дневная модель
        let incomeSumDay = storageSum.getDayObjectForKey(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
        if incomeSumDay.isEmpty{
            let sumModelDay = SumIncomeDayModel(incomeId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModelDay.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumModelDay)
            
        } else {
            let sumModel = SumIncomeDayModel(incomeId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModel.dictOfSumByCategories = incomeSumDay[0].dictOfSumByCategories
            sumModel.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumModel)
        }
        
        //Месячная модель
        let incomeSumMonth = storageSum.getMonthObjectForKey(month: dateComponents.month!, year: dateComponents.year!)
        if incomeSumMonth.isEmpty{
            let sumModelMonth = SumIncomeMonthModel(incomeId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumModelMonth)
        } else {
            let sumModelMonth = SumIncomeMonthModel(incomeId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories = incomeSumMonth[0].dictOfSumByCategories
            sumModelMonth.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumModelMonth)
        }
        
        //Годовая модель
        let incomeSumYear = storageSum.getYearObjectForKey(year: dateComponents.year!)
        if incomeSumYear.isEmpty{
            let sumYearModel = SumIncomeYearModel(incomeId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumYearModel)
        } else {
            let sumYearModel = SumIncomeYearModel(incomeId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories = incomeSumYear[0].dictOfSumByCategories
            sumYearModel.dictOfSumByCategories[category]! += sumIncome
            try! storageSum.saveNewModel(object: sumYearModel)
        }
        
    }
    
}
