import Foundation

class SaveSumObjects{
    
    static func saveSumObjects(dateComponents: DateComponents, category: String, sumCost: Int){
        
        let storageSum = SumCostModelsService()
        
        //Дневная модель
        let costSumDay = storageSum.getDayObjectForKey(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
        if costSumDay == []{
            let sumModelDay = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModelDay.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumModelDay)
            
        } else {
            let sumModel = SumCostDayModel(costId: DateShare.shared.convertFuncDay(dateComponents: dateComponents), dayValue: dateComponents.day!, monthValue: dateComponents.month!, yearValue: dateComponents.year!, keyValue: "day")
            sumModel.dictOfSumByCategories = costSumDay[0].dictOfSumByCategories
            sumModel.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumModel)
        }
        
        //Месячная модель
        let costSumMonth = storageSum.getMonthObjectForKey(month: dateComponents.month!, year: dateComponents.year!)
        if costSumMonth == []{
            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumModelMonth)
        } else {
            let sumModelMonth = SumCostMonthModel(costId: DateShare.shared.convertFuncMonth(dateComponents: dateComponents), yearValue: dateComponents.year!, monthValue: dateComponents.month!, keyValue: "month")
            sumModelMonth.dictOfSumByCategories = costSumMonth[0].dictOfSumByCategories
            sumModelMonth.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumModelMonth)
        }
        
        //Годовая модель
        let costSumYear = storageSum.getYearObjectForKey(year: dateComponents.year!)
        if costSumYear == []{
            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumYearModel)
        } else {
            let sumYearModel = SumCostYearModel(costId: String(Calendar.current.component(.year, from: Date())), yearValue: dateComponents.year!, keyValue: "year")
            sumYearModel.dictOfSumByCategories = costSumYear[0].dictOfSumByCategories
            sumYearModel.dictOfSumByCategories[category]! += sumCost
            try! storageSum.saveNewModel(object: sumYearModel)
        }
        
    }
    
}
