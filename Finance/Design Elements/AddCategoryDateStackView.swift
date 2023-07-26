import UIKit

class AddCategoryDateStackView: UIStackView{
    
    let label = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        label.text = DateShare.shared.convertFunc(dateComponents: dateComponents)
        button.setTitle("Calendar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        axis = .horizontal
        spacing = 10
        distribution = .equalSpacing
        [self.label, self.button].forEach{
            addArrangedSubview($0)
        }
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
