import Foundation
import UIKit

class CategoryIncomeDesignElements{
    
    func getCategoryColors() -> [IncomeCategories.RawValue: UIColor]{
        return ["salary": .blue, "investment": .brown, "gifts": .cyan, "scholarship": .green, "businessIncome": .orange, "salesIncome": .purple, "rentIncome": .red]
    }
    
    func getCategoryEmoji() -> [String: String]{
        return ["salary": "💶", "investment": "💼", "gifts": "🎁", "scholarship": "🏛️", "businessIncome": "📞", "salesIncome": "🎫", "rentIncome": "🏢"]
    }
    
    func getRussianLabelText() -> [String: String]{
        return ["salary": "Зарплата", "investment": "Инвестиции", "gifts": "Подарки", "scholarship": "Стипендия", "businessIncome": "Бизнес", "salesIncome": "Продажи", "rentIncome": "Доход от аренды"]
    }
    
}
