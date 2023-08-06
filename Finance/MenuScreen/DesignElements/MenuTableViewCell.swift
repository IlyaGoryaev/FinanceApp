//
//  MenuTableViewCell.swift
//  Finance
//
//  Created by Илья Горяев on 04.08.2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    let label = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "MenuCell")
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = "123"
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(label)
//        label.text = "123"
//        NSLayoutConstraint.activate([
//            label.centerYAnchor.constraint(equalTo: centerYAnchor),
//            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
//        ])
//
//    }

}
