import Foundation
import UIKit

class CostForGoalCell: UITableViewCell{
    
    let view = UIView()
    let circleView = UIView()
    let labelCost = UILabel()
    let labelPicture = UILabel()
    let nameGoalLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "CostForGoalCell")
        setupView()
        setupCircleView()
        setupLabelCost()
        setupLabelPicture()
        setupNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension CostForGoalCell{
    
    func setupLabelPicture(){
        labelPicture.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelPicture)
        labelPicture.font = .boldSystemFont(ofSize: 40)
        NSLayoutConstraint.activate([
            labelPicture.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            labelPicture.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
    }
    
    func setupView(){
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.14
        view.layer.shouldRasterize = true
        view.layer.shadowRadius = 10
        view.layer.shadowOffset = .zero
        addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 90),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
        ])
    }
    
    func setupCircleView(){
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 35
        addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.heightAnchor.constraint(equalToConstant: 70),
            circleView.widthAnchor.constraint(equalToConstant: 70),
            circleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupNameLabel(){
        
        nameGoalLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameGoalLabel)
        NSLayoutConstraint.activate([
            nameGoalLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 5),
            nameGoalLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        nameGoalLabel.text = "Ноутбук"
    }
    
    func setupLabelCost(){
        labelCost.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelCost)
        NSLayoutConstraint.activate([
            labelCost.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            labelCost.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
}
