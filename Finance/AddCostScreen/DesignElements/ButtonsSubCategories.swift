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
        spacing = 15
        for name in nameButtons!{
            let button = UIButton()
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.lineBreakMode = .byClipping
            button.setTitle(name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 18)
            button.layer.cornerRadius = 5
            button.layer.shadowOffset = .zero
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 10
            button.layer.shadowColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
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
