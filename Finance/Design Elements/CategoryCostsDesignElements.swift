import Foundation
import UIKit
//Временный класс, нужно создать модель в Realm
class CategoryCostsDesignElements{
    
    func getCategoryColors() -> [Categories.RawValue: UIColor]{
        return ["food": #colorLiteral(red: 0.9021778703, green: 0.668946445, blue: 0.1607279181, alpha: 1), "auto": #colorLiteral(red: 0.9719435573, green: 0.295688808, blue: 0.2824983001, alpha: 1), "householdExpenses": #colorLiteral(red: 0.2864229083, green: 0.4874387383, blue: 0.9976932406, alpha: 1), "transport": #colorLiteral(red: 0.4121067226, green: 0.3629536629, blue: 0.749370873, alpha: 1), "houseRent": #colorLiteral(red: 0.5181578994, green: 0.7192596197, blue: 0.4924274087, alpha: 1), "health": .magenta, "sport": .orange, "pets": .systemTeal, "workExpenses": .systemBrown, "other": .brown]
    }
    
    func getCategoryEmoji() -> [String: String]{
        return ["food": "🍴", "auto": "🚗", "householdExpenses": "🛠️", "transport": "🚎", "houseRent": "🏢", "health": "💊", "sport": "⚽️", "pets": "🐶", "workExpenses": "📂", "other": "?"]
    }
    
    func getRussianLabelText() -> [String: String]{
        return ["food": "Еда", "auto": "Автомобиль", "householdExpenses": "Домашние расходы", "transport": "Траспорт", "houseRent": "Аренда жилья", "health": "Здоровье", "sport": "Спорт", "pets": "Питомцы", "workExpenses": "Рабочие расходы", "other": "Другие"]
    }

}
