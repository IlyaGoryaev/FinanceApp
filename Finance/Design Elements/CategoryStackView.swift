import UIKit

class CategoryStackView: UIStackView {
    
    let categoryLabel = UILabel()
    let costButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        [self.categoryLabel, self.costButton].forEach {
            addArrangedSubview($0)
        }
        categoryLabel.text = "Категории"
        categoryLabel.textColor = .white
        costButton.setTitle("Управлять расходами", for: .normal)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
