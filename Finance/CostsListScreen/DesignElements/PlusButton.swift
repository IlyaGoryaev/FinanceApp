import UIKit

final class PlusButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension PlusButton{
    
    func setupStyle(){
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.imageView?.tintColor = UIColor(named: "SemiBoldColor")
        self.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        self.layer.cornerRadius = 25
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
    }
    
}
