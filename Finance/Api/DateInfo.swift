import Foundation

class DateShare{
    
    static var shared = DateShare()
    
    func getYear() -> Int{
        Int(Calendar.current.component(.year, from: Date()))
    }
    
    func getMonth() -> Int{
        Int(Calendar.current.component(.month, from: Date()))
    }
    
    func getDay() -> Int{
        Int(Calendar.current.component(.day, from: Date()))
    }
    
    func convertFunc(dateComponents: DateComponents?) -> String{
        var resultDate: String = ""
        
        if (dateComponents?.day)! > 9{
            
            if (dateComponents?.month)! > 9{
                resultDate = "\(String(describing: dateComponents!.day!)).\(String(describing: dateComponents!.month!))"
            } else {
                resultDate = "\(String(describing: dateComponents!.day!)).0\(String(describing: dateComponents!.month!))"
            }
            
        } else {
            if (dateComponents?.month)! > 9{
                resultDate = "0\(String(describing: dateComponents!.day!)).\(String(describing: dateComponents!.month!))"
            } else {
                resultDate = "0\(String(describing: dateComponents!.day!)).0\(String(describing: dateComponents!.month!))"
            }
        }
        
        return resultDate
    }
}
