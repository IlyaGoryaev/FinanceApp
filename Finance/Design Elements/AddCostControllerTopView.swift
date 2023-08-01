import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddCostControllerTopView: UIView{
    
    let yellowView = UIView()
    let textField = UITextField()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        yellowView.backgroundColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(yellowView)
        addSubview(textField)
        addSubview(label)
        label.text = "Расходы"
        label.textColor = .white
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 20)
        textField.font = UIFont(name: "MochiyPopPOne-Regular", size: 20)
        yellowView.layer.cornerRadius = 20
        textField.placeholder = "0"
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: yellowView.topAnchor, constant: -5),
            yellowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            yellowView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20),
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
