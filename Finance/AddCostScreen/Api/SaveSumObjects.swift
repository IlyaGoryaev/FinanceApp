import Foundation

class SaveSumObjects{
    
    //MARK: Данный класс создан для того, чтобы сразу получать актуальные данные из Realm при необходимости, не высчитывая их каждый раз. Данные сохраняются в дневную модель, которая хранит в себе словарь из сумм расходов по каждой из доступных категорий, в месячную модель, которая аналогично хранит данные за месяц и в годовую модель
    static func saveSumObjects(dateComponents: DateComponents, category: String, sumCost: Int){
        
        let storageSum = SumCostModelsService()
        
        //Дневная модель
        let costSumDay = storageSum.getDayObjectForKey(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
        if costSumDay.isEmpty{
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
        if costSumMonth.isEmpty{
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
        if costSumYear.isEmpty{
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
