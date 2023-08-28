import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class LoginViewModel{
    
    var isRegButtonAvailable = BehaviorSubject(value: false)
    
    var email = BehaviorSubject(value: "")
    
    var password = BehaviorSubject(value: "")
    
    var buttonMode = BehaviorSubject(value: 0)
        
    func getButtonStatus(){
        if RegDataValidation.regEmailValidate(email: try! email.value()) && RegDataValidation.regPasswordValidate(password: try! password.value()){
            isRegButtonAvailable.on(.next(true))
        } else {
            isRegButtonAvailable.on(.next(false))
        }
    }
    
    func tappedButton(){
        let buttonMode = try! buttonMode.value()
        switch buttonMode{
        case 0:
            FirebaseLogin.registerUser(email: try! email.value(), password: try! password.value())
            break
        case 1:
            FirebaseLogin.loginUserWithEmail(email: try! email.value(), password: try! password.value())
            break
        default:
            break
        }
    }
    
    func loginStatus() -> Bool{
        FirebaseLogin.isUserLogIn()
    }
}
