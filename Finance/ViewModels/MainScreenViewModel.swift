import UIKit
import RxCocoa
import RxSwift
import RxDataSources


class MainScreenViewModel{
    
    var labelText = BehaviorSubject(value: "\(StorageService().fetchSumCurrentDay())")
    
    var subLabelText = BehaviorSubject(value: "Cегодня")
    
    var percentArray = BehaviorSubject(value: [0.0])
    
    func getDayLabelText(){
        subLabelText.on(.next("Сегодня"))
        labelText.on(.next("\(StorageService().fetchSumCurrentDay())"))
        print(StorageService().fetchSumCurrentDay())
    }
    
    func getMonthLabelText(){
        subLabelText.on(.next("В этом месяце"))
        labelText.on(.next("\(StorageService().fetchSumCurrentMonth())"))
    }
    
    func getYearLabelText(){
        subLabelText.on(.next("В этом году"))
        labelText.on(.next("\(StorageService().fetchSumCurrentYear())"))
    }
    
    //Исправить
    func getCircleYear(){
        percentArray.on(.next([0.15, 0.25, 0.3, 0.1]))
    }
    
    //Исправить
    func getCircleDay(){
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        let dict = GetStatistic().getDayPercent(dateComponents: dateComponents)
        var array: [Double] = []
        for (category, item) in dict{
            if item != 0{
                if round(item * 100) / 100 >= 0.07{//Исправить
                    array.append(round(item * 100) / 100)
                }
            }
        }
        array = array.sorted(by: { first, second in
            first > second
        })
        print(array)
        percentArray.on(.next(array))
    }
    
    //Исправить
    func getCircleMonth(){
        percentArray.on(.next([0]))
    }
    
}
