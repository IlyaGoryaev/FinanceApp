//import UIKit
//import RxCocoa
//import RxSwift
//import RxDataSources
//class AddCostViewController: UIViewController, UITextFieldDelegate {
//
//    let topView = AddCostControllerTopView()
//    let addCostViewModel = AddCostViewModel()
//    let disposeBag = DisposeBag()
//    
//    //MARK: Кнопка добавления расхода
//    lazy var button: UIButton = {
//        let button = UIButton(frame: .zero)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .systemGray4
//        button.layer.cornerRadius = 25
//        button.setTitle("Добавить", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
//        button.setTitleColor(.systemGray, for: .normal)
//        return button
//    }()
//    
//    lazy var calendarButton: UIButton = {
//       let button = UIButton()
//        button.setImage(UIImage(systemName: "calendar"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.frame.size = CGSizeMake(40, 40)
//        return button
//    }()
//    
//    //MARK: Коллекция категорий расходов
//    lazy var collectionView: UICollectionView = {
//        let collectionViewFlowLayout = UICollectionViewFlowLayout()
//        collectionViewFlowLayout.itemSize = CGSize(width: self.view.frame.height / 10.65, height: self.view.frame.height / 10.65)
//        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
//        collectionView.register(AddCategoryCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .white
//        collectionView.isScrollEnabled = false
//        return collectionView
//    }()
//    
//    
//    lazy var dateSegmetControl: UISegmentedControl = {
//        var items = ["27.01", "28.01", "29.01"]
//       let segmentControl = UISegmentedControl(items: items)
//        segmentControl.selectedSegmentIndex = 0
//        segmentControl.layer.cornerRadius = 5.0
//        segmentControl.backgroundColor = .systemGray5
//        segmentControl.tintColor = .white
//        segmentControl.translatesAutoresizingMaskIntoConstraints = false
//        return segmentControl
//    }()
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        button.isEnabled = false//Кнопка скрыта, когда пользователь не выбрал категорию или не ввел сумму
//        topView.textField.delegate = self
//        let sizeHeight = view.frame.height
//        topView.translatesAutoresizingMaskIntoConstraints = false
//        topView.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
//        view.backgroundColor = .systemGray6
//        view.addSubview(topView)
//        view.addSubview(button)
//        view.addSubview(button)
//        view.addSubview(dateSegmetControl)
//        view.addSubview(calendarButton)
//        NSLayoutConstraint.activate([
//            topView.topAnchor.constraint(equalTo: view.topAnchor),
//            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topView.heightAnchor.constraint(equalToConstant: sizeHeight / 4.26),
//            //изменить
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            button.widthAnchor.constraint(equalToConstant: self.view.frame.width - 210),
//            button.heightAnchor.constraint(equalToConstant: 50),
//            dateSegmetControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
//            dateSegmetControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            dateSegmetControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 * 4),
//            dateSegmetControl.heightAnchor.constraint(equalToConstant: 50),
//            calendarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500),
//            calendarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//        //dateStackView.button.addTarget(self, action: #selector(tappedCalendarButton), for: .touchUpInside)
//        addCostViewModel.fetchCategories()
//        setupCollectionView()
//        bindCollectionView()
//        bindDate()
//        configureButtonAction()
//
//        
//        //MARK: Функция, предназначеннная для отслеживания введенных значений в поле для суммы, если пользователь вместе с корректным значением суммы выбрал категорию, то в данной функции представлена реализация активации кнопки добавления расхода
//        topView.textField.rx.text.subscribe{
//            let isCategorySelected = try! self.addCostViewModel.isCategorySelected.value()
//            _ = try! self.addCostViewModel.sum.value()
//            //Если удается преобразовать введеное пользователем значение суммы, то вполняется дальнейшая логика связи UI и модели
//            if Int($0.element!!) != nil{
//                self.addCostViewModel.getSum(sum: Int($0.element!!)!)
//                if isCategorySelected == true{
//                    self.button.backgroundColor = .blue
//                    self.button.setTitleColor(.white, for: .normal)
//                    self.button.isEnabled = true
//                }
//            } else {
//                self.button.backgroundColor = .systemGray4
//                self.button.setTitleColor(.systemGray2, for: .normal)
//                self.button.isEnabled = false
//                self.addCostViewModel.getSum(sum: 0)
//            }
//        }.disposed(by: disposeBag)
//        
//
//    }
//    
//    //MARK: Добавление расхода по нажатию на кнопку, экран добавления убирается, вызывется функция ViewModel, которая отвечает за сохранение обяъекта в Realm
//    func configureButtonAction(){
//        button.addAction(UIAction(handler: { _ in
//            let value = try! self.addCostViewModel.indexOfItemSelected.value()
//            let category = try! self.addCostViewModel.categories.value()[0].items[value].category.rawValue
//            print(category)
//            self.addCostViewModel.cost.on(.next(CostRealm(costId: UUID().uuidString, date: Date(), sumCost: Int(self.topView.textField.text!)!, label: "fewfewfw", category: category)))
//            self.addCostViewModel.saveRealm()
//            self.dismiss(animated: true)
//        }), for: .touchUpInside)
//        
//    }
//    
//    
//}
//extension AddCostViewController: UIScrollViewDelegate{
//    
//    private func setupCollectionView(){
//        collectionView.layer.cornerRadius = 10
//        collectionView.backgroundColor = .white
//        view.addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            //изменить
//            collectionView.heightAnchor.constraint(equalToConstant: 300)
//        ])
//    }
//    
//    private func bindCollectionView(){
//        
//        //MARK: Связывание коллекции представления категорий с ViewModel
//        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
//        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AddCategoryModel>> { _, collectionView, indexPath, item in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCategoryCell
//            cell.image.image = item.image
//            cell.frame.size = CGSizeMake(80, 80)
//            cell.view.backgroundColor = item.color
//            return cell
//        }
//        addCostViewModel.categories.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
//        
//        //MARK: При выборе ячейки проиходит аналогичный функционал, который реализован, когда введена корректная сумма, также активируется кнопка добавления расхода
//        collectionView.rx.itemSelected.subscribe { indexPath in
//            if let cell = self.collectionView.cellForItem(at: indexPath.element!) as? AddCategoryCell{
//                let previousItemSelected = try! self.addCostViewModel.indexOfItemSelected.value()
//                if previousItemSelected != indexPath.element?.row{
//                    //cell.labelChose.text = "Yes"
//                    UIView.animate(withDuration: 0.1) {
//                        cell.layer.cornerRadius = 5
//                        let color = try! self.addCostViewModel.categories.value()[0].items[indexPath.element!.row].color
//                        cell.backgroundColor = color
//                    }
//                    self.addCostViewModel.categorySelect(isSelect: true)
//                    self.addCostViewModel.itemSelect(index: indexPath.element!.row)
//                    if try! self.addCostViewModel.sum.value() != 0{
//                        self.button.backgroundColor = .blue
//                        self.button.setTitleColor(.white, for: .normal)
//                        self.button.isEnabled = true
//                    }
//                    
//                } else {
//                    //cell.labelChose.text = ""
//                    self.addCostViewModel.categorySelect(isSelect: false)
//                    self.button.backgroundColor = .systemGray4
//                    self.button.setTitleColor(.systemGray2, for: .normal)
//                    self.button.isEnabled = false
//                    self.addCostViewModel.itemSelect(index: -1)
//                    UIView.animate(withDuration: 0.1) {
//                        cell.backgroundColor = .systemGray5
//                    }
//                    
//                }
//            }
//        }.disposed(by: disposeBag)
//        
//        
//        //MARK: Снимается выделение выбранной ранее ячейки
//        collectionView.rx.itemDeselected.subscribe { indexPath in
//            if let cell = self.collectionView.cellForItem(at: indexPath.element!) as? AddCategoryCell{
//                UIView.animate(withDuration: 0.1) {
//                    cell.backgroundColor = .systemGray5
//                }
//            }
//        }.disposed(by: disposeBag)
//        
//    }
//    
//    
//    private func bindDate(){
//        addCostViewModel.date.subscribe{
//            //self.dateStackView.label.text = $0
//        }.disposed(by: disposeBag)
//        
//    }
//}
////MARK: В данном расширение реализуется взаимодействие с кливиатурой, когда пользователь ввел значение, по нажатию return клавиатура скрывается
//extension AddCostViewController{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        topView.textField.resignFirstResponder()
//        return true
//    }
//}
