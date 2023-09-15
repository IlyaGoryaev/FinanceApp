import Foundation

class GetCurrentDateComponents{
    
    static let get = GetCurrentDateComponents()
    
    func day() -> DateComponents{
        
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        
        return dateComponents
    }
    
    func month() -> DateComponents{
        
        var dateComponents = DateComponents()
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        
        return dateComponents
    }
}
