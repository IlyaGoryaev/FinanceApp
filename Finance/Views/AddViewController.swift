import UIKit
import RealmSwift
import RxSwift
import RxCocoa
import RxDataSources


class AddViewController: UIViewController, UICalendarSelectionSingleDateDelegate, UIScrollViewDelegate {

    let calendarView = UICalendarView()
    let dateLabel = UILabel()
    let disposeBag = DisposeBag()
    let textField = UITextField()
    let sumLabelDescription = UILabel()
    let sumLabel = UILabel()
    let button = UIButton()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCalendar()
        configureDateLabel()
        configureTextField()
        configureSumLabelDescription()
        configureSumLabel()
        textField.rx.text.bind {
            self.sumLabelDescription.text = $0
        }.disposed(by: disposeBag)
        configureButton()
    }
    
    private func configureDateLabel(){
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 10)
        ])
        dateLabel.textColor = .black
        dateLabel.text = "ewfew"
        
        
    }
    
    private func configureCalendar(){
        calendarView.calendar = .current
        calendarView.locale = .current
        let dataSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dataSelection
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureTextField(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.placeholder = "Сумма"
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
        ])


    }
    
    private func configureSumLabelDescription(){
        sumLabelDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sumLabelDescription)
        sumLabelDescription.text = String(0)
        NSLayoutConstraint.activate([
            sumLabelDescription.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            sumLabelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
    
    private func configureSumLabel(){
        sumLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sumLabel)
        sumLabel.text = "Сумма"
        NSLayoutConstraint.activate([
            sumLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            sumLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
    }
    
    private func configureButton(){
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 40),
        ])
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
    }
    
    
    @objc func tappedButton(){
        let cost = CostRealm(costId: UUID().uuidString, date: date, sumCost: Int(sumLabelDescription.text!)!, label: "fewe", category: "food")
        let realm = try! Realm()
        try! realm.write({
            realm.add(cost)
        })
        self.dismiss(animated: true)
    }
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        if (dateComponents?.day)! > 9{
            
            if (dateComponents?.month)! > 9{
                dateLabel.text = "\(String(describing: dateComponents!.day!)).\(String(describing: dateComponents!.month!))"
            } else {
                dateLabel.text = "\(String(describing: dateComponents!.day!)).0\(String(describing: dateComponents!.month!))"
            }
            
        } else {
            if (dateComponents?.month)! > 9{
                dateLabel.text = "0\(String(describing: dateComponents!.day!)).\(String(describing: dateComponents!.month!))"
            } else {
                dateLabel.text = "0\(String(describing: dateComponents!.day!)).0\(String(describing: dateComponents!.month!))"
            }
        }
        
        date = (dateComponents?.date!)!
        
    }
}
