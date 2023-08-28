import UIKit

class MenuStatisticsView: UIView{
    
    let leftView = UIView()
    let rightView = UIView()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.frame.size = self.frame.size
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension MenuStatisticsView{
    
    private func setupViews(){
        leftView.backgroundColor = .green
        leftView.frame.size = CGSize(width: self.frame.width / 2, height: self.frame.height)
        rightView.backgroundColor = .red
        rightView.frame.size = CGSize(width: self.frame.width / 2, height: self.frame.height)
    }
    
    private func setupViewConstraints(){
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(rightView)
        
    }
    
}
