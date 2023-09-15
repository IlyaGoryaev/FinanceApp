import UIKit

final class ExitButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension ExitButton{
    
    func setupStyle(){
        self.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        self.layer.cornerRadius = 25
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.imageView?.tintColor = UIColor(named: "SemiBoldColor")
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
    
}
