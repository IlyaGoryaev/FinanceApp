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
        percentArray.on(.next([0]))
    }
    
    //Исправить
    func getCircleMonth(){
        percentArray.on(.next([0]))
    }
    
}
