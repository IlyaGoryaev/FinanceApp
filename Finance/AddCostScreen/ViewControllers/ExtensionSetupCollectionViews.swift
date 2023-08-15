import UIKit
import RxCocoa
import RxSwift
import RxDataSources
//Вынести функции
extension AddCostController{
    
    
    func setupCollectionViewGoals(){
        labelGoals.text = "Цели"
        labelGoals.textColor = .gray
        collectionViewGoals.backgroundColor = .white
        collectionViewGoals.layer.cornerRadius = 10
        stackView.addArrangedSubview(labelGoals)
        stackView.addArrangedSubview(collectionViewGoals)
        print(GoalsService().getAllGoalModels().count)
        var heightOfCollectionView = Double(GoalsService().getAllGoalModels().count) / 5.0 > Double(GoalsService().getAllGoalModels().count / 5) ? Int(GoalsService().getAllGoalModels().count / 5 + 1) * 60 + Int(GoalsService().getAllGoalModels().count / 5 + 1) * 10 + 32 : Int(GoalsService().getAllGoalModels().count / 5) * 60 + Int(GoalsService().getAllGoalModels().count / 5) * 10 + 32
        if GoalsService().getAllGoalModels().count / 5 <= 1{
            heightOfCollectionView = heightOfCollectionView - 10
        }
        
        NSLayoutConstraint.activate([
            collectionViewGoals.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            collectionViewGoals.heightAnchor.constraint(equalToConstant: CGFloat(heightOfCollectionView))
        ])
    }
    
    
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
            dateComponents.day = Calendar.current.component(.day, from: item)
            dateComponents.month = Calendar.current.component(.month, from: item)
            dateComponents.year = Calendar.current.component(.year, from: item)
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
            cell.backgroundColor = .systemPink
            self.calendarButton.backgroundColor = .systemGray5
            self.calendarButton.setTitle("🗓️", for: .normal)
            self.calendarButton.titleLabel?.font = .boldSystemFont(ofSize: 40)
            let arrayDates = try! self.viewModel.datesForSelection.value()
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
        
        labelCategory.text = "Категории"
        labelCategory.textColor = .gray
        collectionViewCategory.backgroundColor = .white
        collectionViewCategory.layer.cornerRadius = 10
        stackView.addArrangedSubview(labelCategory)
        stackView.addArrangedSubview(collectionViewCategory)
        
        NSLayoutConstraint.activate([
            collectionViewCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            collectionViewCategory.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
    
    func bindCollectionViewCategory(){

        let data = Observable.just(CategoryCostsDesignElements().getCategoryEmoji().values)

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
            
            let cellForSubs = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
            
            var selectedCategory: String = ""
            
            for (category, image) in CategoryCostsDesignElements().getCategoryEmoji(){
                if cellForSubs.label.text == image{
                    selectedCategory = category
                }
            }
            
            self.buttonsSubCategories.initButtons(names: CategoryCostsDesignElements().getSubCategory()[selectedCategory])
            
            let selectedIndex = try! self.viewModel.selectedItem.value()["Category"]
            
            if selectedIndex == nil{
                
                if try! self.viewModel.goalsShow.value() == true{
                    
                    let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
                    cell.greenView.isHidden = false
                    cell.labelSelected.isHidden = false
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5695374608, blue: 0, alpha: 1).cgColor
                    
                    
                    
                    self.animateVisabilityGoals()
                    self.labelSubCategories.isHidden = false
                    self.categoriesStackView.isHidden = false
                    
                    
                    self.viewModel.isItemSelected.on(.next(true))
                    self.viewModel.buttonStatus()
                    self.viewModel.goalsShow.on(.next(false))
                    self.viewModel.selectedItem.on(.next(["Category": "\(($0.element!.row))"]))
                    self.viewModel.typeOfSelectedItem.on(.next(cell.label.text!))
                    
                    
                } else {
                    
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    let cell = self.collectionViewCategory.cellForItem(at: $0.element!) as! CategoryCell
                    cell.greenView.isHidden = true
                    cell.labelSelected.isHidden = true
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.clear.cgColor
                    self.viewModel.buttonStatus()
                    self.animateVisabilityGoals()
                    self.labelSubCategories.isHidden = true
                    self.categoriesStackView.isHidden = true
                    
                    self.viewModel.goalsShow.on(.next(true))
                    
                }
                
                
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
                    self.animateVisabilityGoals()
                    
                    self.labelSubCategories.isHidden = true
                    self.categoriesStackView.isHidden = true
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.buttonStatus()
                    self.viewModel.goalsShow.on(.next(true))
                    
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
    
    
    
    func bindCollectionViewGoals(){
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, GoalObject>> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCostGoalCell
            cell.pictureLabel.text = item.picture
            cell.layer.cornerRadius = 30
            cell.pictureLabel.font = .systemFont(ofSize: 40)
            return cell
        }
        collectionViewGoals.rx.itemSelected.subscribe {
            
            let selectedIndex = try! self.viewModel.selectedItem.value()["Goal"]
            
            if selectedIndex == nil{
                
                
                if try! self.viewModel.categoryShow.value() == true{
                    
                    let cell = self.collectionViewGoals.cellForItem(at: $0.element!) as! AddCostGoalCell
                    cell.greenView.isHidden = false
                    cell.labelSelected.isHidden = false
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5695374608, blue: 0, alpha: 1).cgColor
                    
                    
                    self.animateVisabilityCategories()
                    
                    self.viewModel.isItemSelected.on(.next(true))
                    self.viewModel.buttonStatus()
                    self.viewModel.categoryShow.on(.next(false))
                    self.viewModel.selectedItem.on(.next(["Goal": "\(($0.element!.row))"]))
                    self.viewModel.typeOfSelectedItem.on(.next(cell.pictureLabel.text!))
    
                    
                } else {
                    
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.buttonStatus()
                    let cell = self.collectionViewGoals.cellForItem(at: $0.element!) as! AddCostGoalCell
                    cell.greenView.isHidden = true
                    cell.labelSelected.isHidden = true
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.clear.cgColor
                    self.animateVisabilityCategories()
                    self.viewModel.categoryShow.on(.next(true))
                    
                }
            
            } else {
                
                let cell = self.collectionViewGoals.cellForItem(at: $0.element!) as! AddCostGoalCell
                cell.greenView.isHidden = false
                cell.labelSelected.isHidden = false
                cell.layer.borderWidth = 2
                cell.layer.borderColor = #colorLiteral(red: 0, green: 0.5695374608, blue: 0, alpha: 1).cgColor
                
                if Int(selectedIndex!)! == $0.element!.row{
                    
                    
                    let cell = self.collectionViewGoals.cellForItem(at: $0.element!) as! AddCostGoalCell
                    cell.greenView.isHidden = true
                    cell.labelSelected.isHidden = true
                    cell.layer.borderWidth = 2
                    cell.layer.borderColor = UIColor.clear.cgColor
                    self.animateVisabilityCategories()
                    self.viewModel.isItemSelected.on(.next(false))
                    self.viewModel.buttonStatus()
                    self.viewModel.categoryShow.on(.next(true))
                    
                }
                
                self.viewModel.selectedItem.on(.next(["Goal": "\(($0.element!.row))"]))
                self.viewModel.typeOfSelectedItem.on(.next(cell.pictureLabel.text!))
                
            }
            
            if try! self.viewModel.isItemSelected.value() == false{
                self.viewModel.selectedItem.on(.next(["":""]))
            }
            
            
            
        }.disposed(by: disposeBag)
        
        collectionViewGoals.rx.itemDeselected.subscribe {
            
            let cell = self.collectionViewGoals.cellForItem(at: $0.element!) as! AddCostGoalCell
            cell.greenView.isHidden = true
            cell.labelSelected.isHidden = true
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.clear.cgColor
            self.viewModel.buttonStatus()
        }.disposed(by: disposeBag)
        
        
        viewModel.goals.bind(to: collectionViewGoals.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionViewGoals.rx.setDelegate(self).disposed(by: disposeBag)
    }

    
    
    
}
