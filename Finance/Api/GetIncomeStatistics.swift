import Foundation
import RealmSwift

class GetIncomeStatistic{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func getDayPercent(dateComponents: DateComponents) -> ([IncomeCategories.RawValue: Double], [IncomeCategories.RawValue: Int]){
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumIncomeDayModel.self).where {
            $0.incomeId == DateShare.shared.convertFuncDay(dateComponents: dateComponents)
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var incomeSums: [String: Int] = [:]
            var resultDict: [String: Double] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                incomeSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, incomeSums)
        }
    }
    
    func getMonthPercent(dateComponents: DateComponents) -> ([IncomeCategories.RawValue: Double], [IncomeCategories.RawValue: Int]){
        
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumIncomeMonthModel.self).where {
            $0.incomeId == DateShare.shared.convertFuncMonth(dateComponents: dateComponents)
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var incomeSums: [String: Int] = [:]
            var resultDict: [String: Double] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                incomeSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, incomeSums)
        }
    }
    
    func getYearPercent() -> ([IncomeCategories.RawValue : Double], [IncomeCategories.RawValue: Int]){
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumIncomeYearModel.self).where {
            $0.incomeId == String(Calendar.current.component(.year, from: Date()))
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var resultDict: [String: Double] = [:]
            var incomeSums: [String: Int] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                incomeSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, incomeSums)
        }
    }
    
}
