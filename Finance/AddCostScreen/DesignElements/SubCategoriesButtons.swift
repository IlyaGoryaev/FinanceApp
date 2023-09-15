import UIKit

final class ButtonsSubCategories: UIStackView{
    
    var nameButtons: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, names: [String]?) {
        super.init(frame: frame)
        nameButtons = names
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initButtons(names: [String]?){
        self.arrangedSubviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        var buttons: [UIButton] = []
        nameButtons = names
        axis = .vertical
        alignment = .leading
        spacing = 10
        for name in nameButtons!{
            let button = SubButton(name: name, frame: .zero)
            buttons.append(button)
        }
        buttons.forEach{
            addArrangedSubview($0)
        }
    }
}
