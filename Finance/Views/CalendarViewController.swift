//
//  CalendarViewController.swift
//  Finance
//
//  Created by Илья Горяев on 26.07.2023.
//

import UIKit

class CalendarViewController: UIViewController, UICalendarSelectionSingleDateDelegate {
    
    
    
    let calendarView = UICalendarView()
    let exitButton = UIButton()
    let choseButton = UIButton()
    var dateChosenString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        configureExitButton()
        configureChoseButton()
        view.backgroundColor = .white
    }
    
    
        private func configureCalendar(){
            calendarView.calendar = .current
            calendarView.locale = .current
            let dataSelection = UICalendarSelectionSingleDate(delegate: self)
            calendarView.selectionBehavior = dataSelection
            
            calendarView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(calendarView)
            
            NSLayoutConstraint.activate([
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height / 28.4),
                calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    
    private func configureExitButton(){
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.addTarget(self, action: #selector(tappedExitButton), for: .touchUpInside)
        exitButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        NSLayoutConstraint.activate([
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: self.view.frame.height / 56.8),
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: self.view.frame.height / 56.8)
            
        ])
    }
    
    @objc func tappedExitButton(){
        self.dismiss(animated: true)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        dateChosenString = DateShare.shared.convertFunc(dateComponents: dateComponents)
    }
    
    private func configureChoseButton(){
        choseButton.translatesAutoresizingMaskIntoConstraints = false
        choseButton.setTitleColor(.white, for: .normal)
        choseButton.backgroundColor = .blue
        choseButton.setTitle("Выбрать", for: .normal)
        self.view.addSubview(choseButton)
        NSLayoutConstraint.activate([
            choseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            choseButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }

}
