import UIKit

final class AddButtonCost: UIButton {
    
    var view: AddCostController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(view: AddCostController, frame: CGRect) {
        super.init(frame: frame)
        self.view = view
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - Setup style
private extension AddButtonCost{
    
    func setupStyle(){
        self.backgroundColor = .systemGray4
        self.layer.cornerRadius = 25
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
        self.setTitle("✓", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 30)
        self.setTitleColor(.gray, for: .normal)
    }
    
}
// MARK: - Setup tap action
extension AddButtonCost{
    func tappedAddButton(){
        view?.viewModel.saveRealmCost()
    }
}
