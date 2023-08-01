//
//  NavingationController.swift
//  Finance
//
//  Created by Илья Горяев on 31.07.2023.
//

import UIKit

class NavingationController: UIView {
    
    let incomeLabel = UILabel()
    let costLabel = UILabel()
    let chooseView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        self.layer.cornerRadius = 35
        self.addSubview(chooseView)
        chooseView.translatesAutoresizingMaskIntoConstraints = false
        chooseView.backgroundColor = .white
        chooseView.heightAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
