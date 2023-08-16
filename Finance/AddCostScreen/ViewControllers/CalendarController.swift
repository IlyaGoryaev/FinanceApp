//
//  CalendarController.swift
//  Finance
//
//  Created by Илья Горяев on 12.08.2023.
//

import UIKit

class CalendarController: UIViewController {
    
    let viewModel = CalendarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        
    }
    
    func createCalendar(){
        view.backgroundColor = .systemGray6
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.timeZone = .current
        calendarView.fontDesign = .rounded
        calendarView.calendar.firstWeekday = 2
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .white
        calendarView.delegate = self
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
        ])
    }
}
extension CalendarController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        viewModel.selectedDate.on(.next(Calendar.current.date(from: dateComponents!)! + (60 * 60 * 5)))
        
    }
}
