//
//  CollectionViewCell.swift
//  Finance
//
//  Created by Илья Горяев on 26.07.2023.
//

import UIKit

class AddCategoryCell: UICollectionViewCell {
    
    let label = UILabel()
    let labelChose = UILabel()
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 40
        image.translatesAutoresizingMaskIntoConstraints = false
        labelChose.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        addSubview(labelChose)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            labelChose.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelChose.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
