import RxCocoa
import RxSwift
import RxDataSources
import Foundation

class SettingsViewModel{
    
    var authUID = BehaviorSubject(value: "")
    
    func getUID(){
        
        if let uid = FirebaseSettings.getUID(){
            authUID.on(.next(uid))
        } else {
            authUID.on(.next(""))
        }
        
    }
    
}
