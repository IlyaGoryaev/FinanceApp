//
//  DateView.swift
//  Finance
//
//  Created by Илья Горяев on 27.07.2023.
//

import UIKit

class DateView: UIView {
    
    let dateLabel = UILabel()
    let date = UILabel()
    let calendarImage = UIImageView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis = .vertical
        [self.date, self.dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.alignment = .leading
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        date.text = DateShare.shared.convertFunc(dateComponents: dateComponents)
        dateLabel.text = "Дата"
        calendarImage.image = UIImage(systemName: "calendar")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        calendarImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(calendarImage)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            calendarImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarImage.topAnchor.constraint(equalTo: topAnchor),
            calendarImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            calendarImage.trailingAnchor.constraint(equalTo: stackView.leadingAnchor),
            calendarImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
