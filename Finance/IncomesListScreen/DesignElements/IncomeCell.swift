//
//  IncomeCell.swift
//  Finance
//
//  Created by Илья Горяев on 17.08.2023.
//

import UIKit

class IncomeCell: UITableViewCell {

    let view = UIView()
    let labelIncome = UILabel()
    let labelCategory = UILabel()
    let labelComment = UILabel()
    let categoryColorView = UIView()
    let emojiLabel = UILabel()
    let circleView = UIView()
    let stackViewCategory = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "IncomeCell")
        setUpStackViewCategory()
        setupStyle()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStackViewCategory(){
        
        labelComment.font = .boldSystemFont(ofSize: 20)
        labelComment.textColor = .black
        labelCategory.font = .italicSystemFont(ofSize: 18)
        labelCategory.textColor = .gray
        
        stackViewCategory.axis = .vertical
        stackViewCategory.alignment = .leading
        stackViewCategory.spacing = 2
        
        [self.labelComment, self.labelCategory].forEach {
            stackViewCategory.addArrangedSubview($0)
        }
        
        
    }
}
extension IncomeCell{
    
    func setupStyle(){
        self.backgroundColor = UIColor(named: "FinanceBackgroundColor")
        view.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        labelIncome.translatesAutoresizingMaskIntoConstraints = false
        categoryColorView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        circleView.translatesAutoresizingMaskIntoConstraints = false
        stackViewCategory.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = "⚽️"
        emojiLabel.font = .boldSystemFont(ofSize: 40)
        view.layer.cornerRadius = 10
        categoryColorView.layer.cornerRadius = 10
        categoryColorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.layer.shadowOpacity = 0.14
        view.layer.shadowOffset = .zero
        view.layer.shouldRasterize = true
        view.layer.shadowRadius = 10
        categoryColorView.layer.shadowOpacity = 0.14
        categoryColorView.layer.shadowOffset = .zero
        categoryColorView.layer.shouldRasterize = true
        categoryColorView.layer.shadowRadius = 10
        circleView.backgroundColor = UIColor(named: "FinanaceMainScreenCellColor")
        circleView.layer.cornerRadius = 35
    }
    
    func layout(){
        addSubview(view)
        addSubview(labelIncome)
        addSubview(categoryColorView)
        addSubview(circleView)
        addSubview(stackViewCategory)
        circleView.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            labelIncome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            labelIncome.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            categoryColorView.heightAnchor.constraint(equalToConstant: 70),
            categoryColorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryColorView.widthAnchor.constraint(equalToConstant: 10),
            categoryColorView.topAnchor.constraint(equalTo: view.topAnchor),
            circleView.heightAnchor.constraint(equalToConstant: 50),
            circleView.widthAnchor.constraint(equalToConstant: 50),
            circleView.leadingAnchor.constraint(equalTo: categoryColorView.trailingAnchor, constant: 10),
            circleView.centerYAnchor.constraint(equalTo: categoryColorView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            stackViewCategory.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewCategory.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 8)
        ])
        
    }

}
