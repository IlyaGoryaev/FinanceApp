//
//  ButtonsStackView.swift
//  Finance
//
//  Created by Илья Горяев on 25.07.2023.
//

import UIKit

class ButtonsStackView: UIStackView {

    let buttonDay = Button(frame: CGRect(), titleLabel: "День")
    let buttonWeek = Button(frame: CGRect(), titleLabel: "Неделя")
    let buttonMonth = Button(frame: CGRect(), titleLabel: "Месяц")
    let buttonYear = Button(frame: CGRect(), titleLabel: "Год")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        spacing = 15
        alignment = .center
        distribution = .equalSpacing
        [self.buttonDay, self.buttonWeek, self.buttonMonth, self.buttonYear].forEach {
            self.addArrangedSubview($0)
        }
        buttonDay.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonDay.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonWeek.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonMonth.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonYear.widthAnchor.constraint(equalToConstant: 80).isActive = true
        buttonWeek.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonMonth.heightAnchor.constraint(equalToConstant: 40).isActive = true
        buttonYear.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

