import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class ButtonStackViewModel{
    
    var labelInfo = BehaviorSubject(value: "")
    
    func getInfoByPeriod(during title: String){
        let storage = StorageService()
        switch title{
        case "День":
            labelInfo.on(.next(String(storage.fetchSumCurrentDay())))
            break
        case "Месяц":
            labelInfo.on(.next(String(storage.fetchSumCurrentMonth())))
            print(String(storage.fetchSumCurrentMonth()))
            break
        case "Год":
            labelInfo.on(.next(String(storage.fetchSumCurrentYear())))
            print(String(storage.fetchSumCurrentYear()))
            break
        default:
            break
        }
        
    }
    
}
