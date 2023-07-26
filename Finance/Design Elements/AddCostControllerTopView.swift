import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddCostControllerTopView: UIView{
    
    let yellowView = UIView()
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        yellowView.backgroundColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yellowView)
        addSubview(textField)
        textField.font = UIFont(name: "MochiyPopPOne-Regular", size: 20)
        yellowView.layer.cornerRadius = 20
        textField.placeholder = "0"
        NSLayoutConstraint.activate([
            yellowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            yellowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            yellowView.heightAnchor.constraint(equalToConstant: 85),
            yellowView.widthAnchor.constraint(equalToConstant: 180),
            textField.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: yellowView.centerYAnchor),
        ])
        textField.returnKeyType = .done
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
