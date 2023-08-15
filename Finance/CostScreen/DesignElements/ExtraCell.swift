//
//  ExtraCell.swift
//  Finance
//
//  Created by Илья Горяев on 16.08.2023.
//

import UIKit

class ExtraCell: UICollectionViewCell {
    
    let label = UILabel()
    let percentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.7223421931, green: 0.8589904904, blue: 0.9465125203, alpha: 1)
        self.layer.cornerRadius = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.textColor = .gray
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .gray
        label.text = "Прочие\nрасходы"
        label.numberOfLines = 0
        label.textAlignment = .left
        addSubview(label)
        addSubview(percentLabel)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            percentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
