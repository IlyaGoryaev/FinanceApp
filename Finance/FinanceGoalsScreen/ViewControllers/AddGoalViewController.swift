import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class AddGoalViewController: UIViewController, UIScrollViewDelegate {
    
    let disposeBag = DisposeBag()
    
    //MARK: Кнопки наверху контроллера
    let exitButton = UIButton()
    
    //MARK: Инициализация текстового поля
    let sumTextField = UITextField()
    let goalNameTextField = UITextField()
    
    let viewModel = AddGoalViewModel()
    
    //MARK: Labels
    let sumLabel = UILabel()
    let goalNameLabel = UILabel()
    
    
    //MARK: Scroll View
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    //MARK: Контейнер для ScrollView
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        contentView.frame.size = contentSize
        return contentView
    }()
    
    //MARK: StackView в котором располагаются элементы
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    //MARK: Размер контента внутри scrollView
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 82)
        ])
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupViewConstraints()
        setupTextField()
        setupGoalNameTexField()
        
        setupExitButton()
    }
}
extension AddGoalViewController{
    
    private func setupViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupGoalNameTexField(){
        
        goalNameLabel.text = "Название"
        goalNameLabel.textColor = .gray
        stackView.addArrangedSubview(goalNameLabel)
        
        stackView.addArrangedSubview(goalNameTextField)
        goalNameTextField.borderStyle = .roundedRect
        goalNameTextField.layer.borderColor = UIColor.gray.cgColor
        goalNameTextField.placeholder = "Путешествие"
        goalNameTextField.textAlignment = .right
        goalNameTextField.font = .systemFont(ofSize: 30)
        goalNameTextField.layer.borderWidth = 1
        goalNameTextField.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            goalNameTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            goalNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupTextField(){
        
        sumLabel.text = "Cумма цели"
        sumLabel.textColor = .gray
        stackView.addArrangedSubview(sumLabel)
        
        stackView.addArrangedSubview(sumTextField)
        sumTextField.borderStyle = .roundedRect
        sumTextField.layer.borderColor = UIColor.gray.cgColor
        sumTextField.placeholder = "1000₽"
        sumTextField.textAlignment = .right
        sumTextField.font = .systemFont(ofSize: 30)
        sumTextField.layer.borderWidth = 1
        sumTextField.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            sumTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 16),
            sumTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        sumTextField.rx.text.subscribe {
            if let sumInt = Int($0.element!!){
                self.viewModel.sum.on(.next(sumInt))
                //self.viewModel.buttonStatus()
            } else {
                self.viewModel.sum.on(.next(0))
                //self.viewModel.buttonStatus()
            }
        }.disposed(by: disposeBag)

        self.viewModel.sum.subscribe {
            print($0)
        }.disposed(by: disposeBag)
    }
    
    private func setupExitButton(){
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.backgroundColor = .white
        view.addSubview(exitButton)
        exitButton.layer.cornerRadius = 25
        exitButton.layer.shadowOpacity = 0.15
        exitButton.layer.shadowOffset = .zero
        exitButton.layer.shouldRasterize = true
        exitButton.layer.shadowRadius = 10
        exitButton.setTitle("✕", for: .normal)
        exitButton.titleLabel?.font = .systemFont(ofSize: 30)
        exitButton.setTitleColor(.gray, for: .normal)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
        exitButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
}
