import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class IncomeModelView{
    
    var incomes = BehaviorSubject(value: [SectionModel(model: "", items: [IncomeRealm]())])
    
    var selectedIndex = BehaviorSubject(value: 0)
    
    func fetchIncomes(){
        let storage = IncomeStorageService()
        var arraySection: [any SectionModelType] = []
        for date in storage.fetchAllDates().sorted().reversed(){
            var dateComponents = DateComponents()
            dateComponents.timeZone = .current
            dateComponents.day = Calendar.current.component(.day, from: date)
            dateComponents.month = Calendar.current.component(.month, from: date)
            dateComponents.year = Calendar.current.component(.year, from: date)
            arraySection.append(SectionModel(model: DateShare.shared.convertFuncDay(dateComponents: dateComponents), items: storage.fetchByDate(day: Calendar.current.component(.day, from: date), month: Calendar.current.component(.month, from: date), year: Calendar.current.component(.year, from: date)).reversed()))
        }
        incomes.on(.next(arraySection as! [SectionModel<String, IncomeRealm>]))
    }
    
    func fetchDayIncomes(){
        let storage = IncomeStorageService()
        var array = storage.fetchByDate(day: Calendar.current.component(.day, from: Date()), month: Calendar.current.component(.month, from: Date()), year: Calendar.current.component(.year, from: Date()))
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        array = array.sorted { cost1, cost2 in
            cost1.date >= cost2.date
        }
        if array != []{
            incomes.on(.next([SectionModel(model: DateShare.shared.convertFuncDay(dateComponents: dateComponents), items: array)]))
        } else {
            incomes.on(.next([SectionModel(model: "", items: [IncomeRealm]())]))
        }
    }
    
    func fetchMonthIncomes(){
        let storage = IncomeStorageService()
        var monthArray: [any SectionModelType] = []
        var costsArray: [[IncomeRealm?]] = [[IncomeRealm?]].init(repeating: [nil], count: 32)
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let array = storage.fetchObjectsByMonth(month: dateComponents.month!, year: dateComponents.year!)
        
        for cost in array{
            
            var dateComponents = DateComponents()
            dateComponents.timeZone = .current
            dateComponents.day = Calendar.current.component(.day, from: cost.date)
            dateComponents.month = Calendar.current.component(.month, from: cost.date)
            dateComponents.year = Calendar.current.component(.year, from: cost.date)
            if costsArray[dateComponents.day!] == [nil]{
                costsArray[dateComponents.day!] = [cost]
            } else {
                costsArray[dateComponents.day!].append(cost)
            }
            
            
        }
        var i = 31
        while(i > 0){
            
            if costsArray[i] != [nil]{
                var dateComponents = DateComponents()
                dateComponents.timeZone = .current
                costsArray[i] = costsArray[i].sorted { cost1, cost2 in
                    cost1!.date >= cost2!.date
                }
                dateComponents.day = i
                dateComponents.month = Calendar.current.component(.month, from: Date())
                dateComponents.year = Calendar.current.component(.year, from: Date())
                monthArray.append(SectionModel(model: DateShare.shared.convertFuncDay(dateComponents: dateComponents), items: costsArray[i] as! [IncomeRealm]))
            }
            
            i -= 1
            
        }
        
        incomes.on(.next(monthArray as! [SectionModel<String, IncomeRealm>]))
    }
    
    
    func fetchWeekIncomes(){
        
        var array: [any SectionModelType] = []
        let now = Date() + (60 * 60 * 5)
        let daysWeek = Calendar.current.component(.weekday, from: Date()) == 1 ? 7 : Calendar.current.component(.weekday, from: Date()) - 1
        var datesBefore = daysWeek - 1
        var datesAfter = 7 - daysWeek
        for i in 1...datesBefore{
            var date: Date = now - TimeInterval((60 * 60 * 24 * i))
            insertElement(array: &array, date: date, isInsert: false)
            
        }
        insertElement(array: &array, date: now, isInsert: true)
        for i in 1...datesAfter{
            var date: Date = now + TimeInterval((60 * 60 * 24 * i))
            insertElement(array: &array, date: date, isInsert: true)
        }
        incomes.on(.next(array as! [SectionModel<String, IncomeRealm>]))
    }
    
    func insertElement(array: inout [any SectionModelType], date: Date, isInsert: Bool){
        let storage = IncomeStorageService()
        var dateComponents = DateComponents()
        dateComponents.timeZone = .current
        dateComponents.day = Calendar.current.component(.day, from: date)
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.year = Calendar.current.component(.year, from: date)
        var dailyArray = storage.fetchByDate(day: dateComponents.day!, month: dateComponents.month!, year: dateComponents.year!)
        dailyArray = dailyArray.sorted { cost1, cost2 in
            cost1.date >= cost2.date
        }
        if !dailyArray.isEmpty{
            if isInsert{
                array.insert(SectionModel(model: DateShare().convertFuncDay(dateComponents: dateComponents), items: dailyArray), at: 0)
            } else {
                array.append(SectionModel(model: DateShare().convertFuncDay(dateComponents: dateComponents), items: dailyArray))
            }
            
        }
        
    }
    
    
    func fetchObjectsAfterAddingNewIncome(){
        
        let selectedIndex = try! selectedIndex.value()
        
        switch selectedIndex{
        case 0:
            fetchDayIncomes()
            break
        case 1:
            fetchWeekIncomes()
            break
        case 2:
            fetchMonthIncomes()
            
            break
        default:
            break
        }
        
    }
    
}
