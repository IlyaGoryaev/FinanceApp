import Foundation
import RealmSwift

class GetCostStatistic{
    private let storage: Realm?
    
    init() {
        let realm = try! Realm()
        self.storage = realm
    }
    
    func getDayPercent(dateComponents: DateComponents) -> ([Categories.RawValue: Double], [Categories.RawValue: Int]){
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumCostDayModel.self).where {
            $0.costId == DateShare.shared.convertFuncDay(dateComponents: dateComponents)
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var costSums: [String: Int] = [:]
            var resultDict: [String: Double] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                costSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, costSums)
        }
    }
    
    func getMonthPercent(dateComponents: DateComponents) -> ([Categories.RawValue: Double], [Categories.RawValue: Int]){
        
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumCostMonthModel.self).where {
            $0.costId == DateShare.shared.convertFuncMonth(dateComponents: dateComponents)
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var costSums: [String: Int] = [:]
            var resultDict: [String: Double] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                costSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, costSums)
        }
        
    }
    
    func getYearPercent() -> ([Categories.RawValue : Double], [Categories.RawValue: Int]){
        guard let storage else { return ([:], [:]) }
        let dict = storage.objects(SumCostYearModel.self).where {
            $0.costId == String(Calendar.current.component(.year, from: Date()))
        }.toArray()
        if dict == []{
            return ([:], [:])
        } else {
            var sum = 0
            var resultDict: [String: Double] = [:]
            var costSums: [String: Int] = [:]
            for item in dict[0].dictOfSumByCategories{
                sum += item.value
                costSums[item.key] = item.value
            }
            for item in dict[0].dictOfSumByCategories{
                resultDict[item.key] = Double(item.value) / Double(sum)
            }
            return (resultDict, costSums)
        }
    }
    
    
}
