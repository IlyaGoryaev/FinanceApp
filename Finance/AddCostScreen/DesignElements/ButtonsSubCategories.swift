import UIKit

class ButtonsSubCategories: UIStackView{
    
    var nameButtons: [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    init(frame: CGRect, names: [String]?) {
        super.init(frame: frame)
        nameButtons = names
        
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
        spacing = 5
        for name in nameButtons!{
            var button = UIButton()
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            buttons.append(button)
        }
        buttons.forEach{
            addArrangedSubview($0)
        }
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
