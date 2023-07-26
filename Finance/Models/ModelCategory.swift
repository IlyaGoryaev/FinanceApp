import Foundation
import UIKit


struct CategoryModel{
    
    var category: Categories
    var usage: Int
    var image: UIImage?
    
    
    init(category: Categories, usage: Int, image: UIImage? = nil) {
        self.category = category
        self.usage = usage
        self.image = image
    }
}
