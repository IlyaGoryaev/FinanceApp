//
//  CellForMainScreen.swift
//  Finance
//
//  Created by Илья Горяев on 30.07.2023.
//

import UIKit

class CellForMainScreen: UICollectionViewCell {
    
    let sumLabel = UILabel()
    let categoryLabel = UILabel()
    let percentLabel = UILabel()
    let colorImage = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sumLabel.text = "694"
        sumLabel.font = .boldSystemFont(ofSize: 17)
        sumLabel.textColor = .gray
        categoryLabel.text = "Food"
        categoryLabel.font = .systemFont(ofSize: 14)
        categoryLabel.textColor = .systemGray2
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        colorImage.backgroundColor = #colorLiteral(red: 0.5433602929, green: 0.7548330426, blue: 0.5191312432, alpha: 1)
        colorImage.layer.cornerRadius = 8
        colorImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorImage)
        addSubview(sumLabel)
        addSubview(categoryLabel)
        addSubview(percentLabel)
        percentLabel.text = "20%"
        percentLabel.font = .systemFont(ofSize: 17)
        percentLabel.textColor = .gray
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sumLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sumLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            categoryLabel.topAnchor.constraint(equalTo: sumLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            colorImage.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            colorImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            colorImage.widthAnchor.constraint(equalToConstant: 16),
            colorImage.heightAnchor.constraint(equalToConstant: 16),
            percentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
