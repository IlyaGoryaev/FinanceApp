import UIKit
import RxCocoa
import RxSwift
import RxDataSources
class AddCostViewController: UIViewController, UITextFieldDelegate {

    let topView = AddCostControllerTopView()
    let addCostViewModel = AddCostViewModel()
    let disposeBag = DisposeBag()
    let dateLabel = UILabel()
    let commentLabel = UILabel()
    let commentView = UITextView()
    let dateView = DateView()
    //let dateStackView = AddCategoryDateStackView()
    let button = UIButton()
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.itemSize = CGSize(width: self.view.frame.height / 10.65, height: self.view.frame.height / 10.65)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(AddCategoryCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.textField.delegate = self
        let sizeHeight = view.frame.height
        topView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateView.translatesAutoresizingMaskIntoConstraints = false
        commentView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        commentView.backgroundColor = .systemGray6
        topView.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        dateLabel.text = "Дата"
        commentLabel.text = "Комментарий"
        commentView.rx.text.subscribe {
            print($0.element!!)
        }.disposed(by: disposeBag)
        dateView.backgroundColor = .blue
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .blue
        view.backgroundColor = .white
        view.addSubview(topView)
        view.addSubview(dateLabel)
        view.addSubview(commentLabel)
        view.addSubview(commentView)
        view.addSubview(button)
        view.addSubview(dateView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: sizeHeight / 4.26),
            //изменить
            dateView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 300),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dateView.widthAnchor.constraint(equalToConstant: 100),
            commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentLabel.topAnchor.constraint(equalTo: dateView.bottomAnchor),
            commentView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 15),//Изменить
            commentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),//Изменить
            commentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),//Измтмленить
            commentView.heightAnchor.constraint(equalToConstant: 100),//Изменить
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        //dateStackView.button.addTarget(self, action: #selector(tappedCalendarButton), for: .touchUpInside)
        addCostViewModel.fetchCategories()
        setupCollectionView()
        bindCollectionView()
        bindDate()
        configureButtonAction()

    }
    
    @objc func tappedCalendarButton(){
        let controller = CalendarViewController()
        controller.choseButton.addAction(UIAction(handler: {_ in
            self.addCostViewModel.date.on(.next(controller.dateChosenString))
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        self.present(controller, animated: true)
    }
    
    func configureButtonAction(){
        
        button.addAction(UIAction(handler: { _ in
            var category: String? = nil
            let array = try! self.addCostViewModel.categories.value()[0]
            for i in 0...array.items.count - 1{
                let cell = self.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? AddCategoryCell
                if cell?.labelChose.text != nil{
                    category = array.items[i].category.rawValue
                }
                if category != nil{
                    break
                }
            }
            //Исправить
            print(category)
            let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? AddCategoryCell
            if self.topView.textField.text != "" && category != nil{
                
                self.addCostViewModel.cost.on(.next(CostRealm(costId: UUID().uuidString, date: Date(), sumCost: Int(self.topView.textField.text!)!, label: self.commentLabel.text!, category: category!)))
                self.addCostViewModel.saveRealm()
                self.dismiss(animated: true)
            }
            category = nil
        }), for: .touchUpInside)
        
    }//Доработать
    
    
}
extension AddCostViewController: UIScrollViewDelegate{
    
    private func setupCollectionView(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //изменить
            collectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func bindCollectionView(){
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, AddCategoryModel>> { _, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AddCategoryCell
            cell.image.image = item.image
            cell.backgroundColor = item.color
            return cell
        }
        addCostViewModel.categories.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        collectionView.rx.itemSelected.subscribe { indexPath in
            if let cell = self.collectionView.cellForItem(at: indexPath.element!) as? AddCategoryCell{
                cell.labelChose.text = "Yes"
                //Двойное нажатие
            }
        }.disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected.subscribe { indexPath in
            if let cell = self.collectionView.cellForItem(at: indexPath.element!) as? AddCategoryCell{
                cell.labelChose.text = nil
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    private func bindDate(){
        addCostViewModel.date.subscribe{
            //self.dateStackView.label.text = $0
        }.disposed(by: disposeBag)
        
    }
}
extension AddCostViewController{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topView.textField.resignFirstResponder()
        return true
    }
}
