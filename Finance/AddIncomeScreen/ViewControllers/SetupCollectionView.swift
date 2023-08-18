import UIKit
import RxCocoa
import RxSwift
import RxDataSources

extension AddIncomeViewController: UIScrollViewDelegate{
    
    func setupDateCollectionView(){
        stackView.addArrangedSubview(dateCollectionView)
        dateCollectionView.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            dateCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 100),
            dateCollectionView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func bindDateCollectionView(){
        
        self.viewModel.datesForSelection.bind(to: dateCollectionView.rx.items){collectionView, index, item in
            let indexPath = IndexPath(row: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DateCell
            var dateComponents = DateComponents()
            var calendar = Calendar.current
            calendar.timeZone = .current
            calendar.locale = .current
            dateComponents.timeZone = .current
            dateComponents.calendar = .current
            dateComponents.day = calendar.component(.day, from: item)
            dateComponents.month = calendar.component(.month, from: item)
            dateComponents.year = calendar.component(.year, from: item)
            cell.label.text = DateShare.shared.convertFuncDayWithoutYear(dateComponents: dateComponents)
            cell.backgroundColor = .systemGray5
            cell.layer.cornerRadius = 10
            cell.layer.borderColor = UIColor.systemGray2.cgColor
            cell.layer.borderWidth = 1
            cell.layer.shadowOffset = .zero
            cell.layer.shadowOpacity = 0.1
            return cell
        }.disposed(by: disposeBag)
        
        
        
        dateCollectionView.rx.itemSelected.subscribe {
            let cell = self.dateCollectionView.cellForItem(at: $0.element!) as! DateCell
            cell.backgroundColor = #colorLiteral(red: 0.985034883, green: 0.8090179563, blue: 0.7341457605, alpha: 1)
            self.calendarButton.backgroundColor = .systemGray5
            self.calendarButton.setTitle("🗓️", for: .normal)
            self.calendarButton.titleLabel?.font = .boldSystemFont(ofSize: 40)
            let arrayDates = try! self.viewModel.datesForSelection.value()
            //Тестирование добавления дат
            self.viewModel.dateSelected.on(.next(arrayDates[$0.element!.row]))
            self.viewModel.isDateSelected.on(.next(true))
            self.viewModel.buttonStatus()
            
        }.disposed(by: disposeBag)
        
        dateCollectionView.rx.itemDeselected.subscribe {
            let cell = self.dateCollectionView.cellForItem(at: $0) as! DateCell
            cell.backgroundColor = .systemGray5
            cell.label.textColor = .label
            
        }.disposed(by: disposeBag)
        
        dateCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    func setupCollectionViewCategory(){
        var constant: Double = 0.0
        if self.view.frame.height > 820{
            constant = 5.0
        } else {
            constant = 4.0
        }
        
        var heightOfCollectionView = Double(IncomeCategories.allCases.count) / constant > Double(IncomeCategories.allCases.count / Int(constant)) ? Int(IncomeCategories.allCases.count / Int(constant) + 1) * 60 + Int(IncomeCategories.allCases.count / Int(constant) + 1) * 10 + 32 : Int(IncomeCategories.allCases.count / Int(constant)) * 60 + Int(IncomeCategories.allCases.count / Int(constant)) * 10 + 32
        labelCategory.text = "Категории"
        labelCategory.textColor = .gray
        collectionViewCategory.backgroundColor = .white
        collectionViewCategory.layer.cornerRadius = 10
        stackView.addArrangedSubview(labelCategory)
        stackView.addArrangedSubview(collectionViewCategory)
        
        NSLayoutConstraint.activate([
            collectionViewCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            collectionViewCategory.heightAnchor.constraint(equalToConstant: CGFloat(heightOfCollectionView))
        ])
    }
    
    func bindCollectionViewCategory(){

        let data = Observable.just(CategoryIncomeDesignElements().getCategoryEmoji().values)

        data.bind(to: collectionViewCategory.rx.items){collectionView, index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCell
            cell.label.text = item
            cell.label.font = .systemFont(ofSize: 40)
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 30
            return cell
        }.disposed(by: disposeBag)
        
        collectionViewCategory.rx.itemSelected.subscribe {
            let selectedIndex = try! self.viewModel.selectedItem.value()["Category"]
            
            if selectedIndex == nil{
                let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
                cell.greenView.isHidden = false
                cell.labelSelected.isHidden = false
                cell.layer.borderWidth = 2
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5695374608, blue: 0, alpha: 1).cgColor
                
                self.viewModel.isItemSelected.on(.next(true))
                self.viewModel.buttonStatus()
                self.viewModel.selectedItem.on(.next(["Category": "\(($0.element!.row))"]))
                self.viewModel.typeOfSelectedItem.on(.next(cell.label.text!))
            } else {
                
                let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
                
                cell.greenView.isHidden = false
                cell.labelSelected.isHidden = false
                cell.layer.borderWidth = 2
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5695374608, blue: 0, alpha: 1).cgColor
                
                if Int(selectedIndex!)! == $0.element!.row{
                    
                    
                    let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
                    cell.greenView.isHidden = true
                    cell.labelSelected.isHidden = true
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.clear.cgColor
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.buttonStatus()
                    
                }
                self.viewModel.selectedItem.on(.next(["Category": "\(($0.element!.row))"]))
                self.viewModel.typeOfSelectedItem.on(.next(cell.label.text!))
                
            }
            if try! self.viewModel.isItemSelected.value() == false{
                self.viewModel.selectedItem.on(.next(["":""]))
            }
        }.disposed(by: disposeBag)
        
        collectionViewCategory.rx.itemDeselected.subscribe {
            let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
            cell.greenView.isHidden = true
            cell.labelSelected.isHidden = true
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.clear.cgColor
            self.viewModel.buttonStatus()
        }.disposed(by: disposeBag)

        collectionViewCategory.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
}
