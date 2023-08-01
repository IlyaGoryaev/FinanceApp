//
//  CollectionViewCell.swift
//  Finance
//
//  Created by Илья Горяев on 26.07.2023.
//

import UIKit

class AddCategoryCell: UICollectionViewCell {
    
    let label = UILabel()
    let image = UIImageView()
    let view = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view.layer.cornerRadius = 30
        image.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        addSubview(view)
        view.addSubview(image)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 40),
            image.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
