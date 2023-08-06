import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//Решить проблему с добалением view в стек
//компановка элементов
//Удаление слоев
//Распознавание жестов над слоями
//рефакторинг кода
protocol CostScreenDelegate: AnyObject{
    func didTapButtonMenu()
}

class CostScreen: UIViewController {
    
    //MARK: Кнопка бокового меню
    let menuIcon = MenuIcon.build(color: .brown, frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    let addButton = UIButton()
    
    //MARK: Круговая диаграмма трат
    let viewWithCircleContainer = UIView()
    let label = UILabel()
    let subLabel = UILabel()
    
    //MARK: Состояния вида, которые расширяется и скалдывается
    enum CardState{
        case expand
        case collapsed
    }
    
    var arrayOfCategoriesSection = [Categories.RawValue: Double]()
    
    let disposeBag = DisposeBag()
    
    
    weak var delegate: CostScreenDelegate?
    
    //MARK: Тестовые кнопки
    let buttons = Buttons()
    
    //MARK: Инициализация viewModel
    private var viewModel = CostScreenViewModel()
    
    //MARK: Контроллер вида, который находится в нижнем View
    var cardViewController: CardViewController!
    
    //MARK: Визуальные эффекты, которые
    var visualEffectView: UIVisualEffectView!
    
    //MARK: Высота контролллера в двух режимах
    let cardHeightPercentage = 0.95//переделать
    let cardHandleAreaHeightPercentage = 0.35// переделать
    
    //MARK: Свойства, которые отвечает за состояние вида
    var cardVisible = false
    var nextState: CardState{
        return cardVisible ? .collapsed : .expand
    }
    
    //MARK: Виды анимаций, которые запускает UIViewPropertyAnimator
    var runningAnimation = [UIViewPropertyAnimator]()
    
    
    var animationProgressWhenInterrupted: CGFloat = 0
    
    var height = UIApplication.shared.delegate?.window?!.windowScene?.keyWindow?.frame.height
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.cardViewController.viewModel.getDayStatistics()
        viewModel.getCircleDay()
        viewModel.getDayLabelText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.height / self.view.frame.width)
        //MARK: Настройка кнопки меню
        menuIcon.translatesAutoresizingMaskIntoConstraints = false
        menuIcon.backgroundColor = .white
        view.addSubview(menuIcon)
        NSLayoutConstraint.activate([
            menuIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            menuIcon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuIcon.heightAnchor.constraint(equalToConstant: 50),
            menuIcon.widthAnchor.constraint(equalToConstant: 50)
        ])
        let tapMenuIconGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMenuButton))
        menuIcon.addGestureRecognizer(tapMenuIconGesture)
        
        
        viewModel.getCircleDay()
        var dateComponents = DateComponents()
        dateComponents.day = Calendar.current.component(.day, from: Date())
        dateComponents.month = Calendar.current.component(.month, from: Date())
        dateComponents.year = Calendar.current.component(.year, from: Date())
        print(GetStatistic().getDayPercent(dateComponents: dateComponents))
        self.navigationController?.navigationBar.isHidden = true
        view.addSubview(viewWithCircleContainer)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
        addButton.setTitleColor(.gray, for: .normal)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: viewWithCircleContainer.trailingAnchor, constant: 16),
            addButton.bottomAnchor.constraint(equalTo: viewWithCircleContainer.bottomAnchor, constant: 16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 25
        addButton.layer.shadowOpacity = 0.4
        addButton.addTarget(self, action: #selector(addMenu), for: .touchUpInside)
        
        
        viewModel.percentArray.subscribe {
            self.arrayOfCategoriesSection = $0
        }.disposed(by: disposeBag)
        
        //MARK: Настройка тестовых кнопок
        buttons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        
        
        //MARK: Настройка view в котором расположена круговая диаграмма
        view.backgroundColor = .systemBackground
        viewWithCircleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewWithCircleContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(self.view.frame.height * cardHandleAreaHeightPercentage) - 50),
            viewWithCircleContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewWithCircleContainer.heightAnchor.constraint(equalToConstant: view.frame.width * 0.76),
            viewWithCircleContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.76)
            
        ])
        viewWithCircleContainer.backgroundColor = .white
        
        //MARK: Добавление слоев круговой диаграммы
        for layer in CircleCategories(circleValue: Int(view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: arrayOfCategoriesSection){
            viewWithCircleContainer.layer.addSublayer(layer)
            print(layer)
        }
        
        
        
        setupLabel()
        
        //buttons.buttonMonth.addTarget(self, action: #selector(tappedMonthButton(sender: )), for: .touchUpInside)
        
        //кнопка не работает после добавления child View Controller
        
        setUpCard()
        
        setUpButtons()
        
        self.cardViewController.collectionView.rx.itemSelected.subscribe { indexPath in
            let cell = self.cardViewController.collectionView.cellForItem(at: indexPath.element!) as? CellForCostScreen
            let controller = ListSortedCostsViewController(category: (cell?.categoryLabel.text)!, nibName: nil, bundle: nil)
            controller.view.backgroundColor = cell?.colorImage.backgroundColor
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
    @objc func tappedMenuButton(){
        self.delegate?.didTapButtonMenu()
        
    }
    
    
    @objc func addMenu(){
        let controller = CostViewController()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: Настройка компонентов внутри круговой диаграммы
    func setupLabel(){
        viewModel.labelText.subscribe{
            self.label.text = $0
        }.disposed(by: disposeBag)
        viewModel.subLabelText.subscribe {
            self.subLabel.text = $0
        }.disposed(by: disposeBag)
        label.font = .boldSystemFont(ofSize: 40)//Исправить под значение
        subLabel.font = .systemFont(ofSize: 20)
        label.textColor = .black
        subLabel.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        viewWithCircleContainer.addSubview(label)
        viewWithCircleContainer.addSubview(subLabel)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewWithCircleContainer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewWithCircleContainer.centerYAnchor, constant: 10),
            subLabel.centerXAnchor.constraint(equalTo: viewWithCircleContainer.centerXAnchor),
            subLabel.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5)
        ])
    }
    
    
    //MARK: Настройка кнопок
    func setUpButtons(){
        buttons.buttonDay.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonMonth.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonYear.titleLabel?.font = .boldSystemFont(ofSize: self.view.frame.width * 0.09)
        buttons.buttonDay.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.black, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonYear.setTitleColor(.systemGray2, for: .normal)
            self.cardViewController.viewModel.getDayStatistics()
            self.viewModel.getDayLabelText()
            self.viewModel.getCircleDay()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for:  .touchUpInside)
        
        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.black, for: .normal)
            self.buttons.buttonYear.setTitleColor(.systemGray2, for: .normal)
            self.cardViewController.viewModel.getMonthStatistics()//Убрать
            self.viewModel.getMonthLabelText()
            self.viewModel.getCircleMonth()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for: .touchUpInside)
        
        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.buttons.buttonDay.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonMonth.setTitleColor(.systemGray2, for: .normal)
            self.buttons.buttonYear.setTitleColor(.black, for: .normal)
            self.cardViewController.viewModel.getYearStatistics()
            self.viewModel.getYearLabelText()
            self.viewModel.getCircleYear()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories(circleValue: Int(self.view.frame.width * 0.76) / 2).getCategoriesLayer(percentDict: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
                print(layer)
            }
        }), for: .touchUpInside)
    }
    
    
    
    
    //MARK: Функция настройки карточки
    func setUpCard(){
        cardViewController = CardViewController()
        self.addChild(cardViewController)
        self.didMove(toParent: self)
        
        self.view.addSubview(cardViewController.view)
        cardViewController.didMove(toParent: self)
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.view.frame.height * cardHandleAreaHeightPercentage), width: self.view.frame.width, height: self.view.frame.height * cardHeightPercentage)
        
        cardViewController.view.clipsToBounds = true
        self.cardViewController.view.layer.cornerRadius = 20
        cardViewController.view.layer.masksToBounds = false
        
        cardViewController.view.layer.shadowRadius = 20
        cardViewController.view.layer.shadowColor = UIColor.black.cgColor
        cardViewController.view.layer.shadowPath = UIBezierPath(roundedRect: cardViewController.view.bounds, cornerRadius: cardViewController.view.layer.cornerRadius).cgPath
        cardViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cardViewController.view.layer.shadowOpacity = 0.15
        
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeUp(recognizer: )))
        swipeGestureRecognizer.direction = .up
        cardViewController.view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    //    @objc func handleCardTap(recognizer: UITapGestureRecognizer){
    //        switch recognizer.state{
    //        case .ended:
    //            animateTransitionIfNeeded(state: nextState, duration: 0.9)
    //        default:
    //            break
    //        }
    //    }
    
    @objc func handleSwipeUp(recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction{
        case .up:
            animateTransitionIfNeeded(state: nextState, duration: 0.7)
        default:
            break
        }
    }
    
    
    @objc func handleSwipeDown(recognizer: UISwipeGestureRecognizer){
        switch recognizer.direction{
        case .down:
            animateTransitionIfNeeded(state: nextState, duration: 0.7)
        default:
            break
        }
    }
    
    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval){
        
        if runningAnimation.isEmpty{
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1){
                switch state{
                case .expand:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - (self.view.frame.height * self.cardHeightPercentage)
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - (self.view.frame.height * self.cardHandleAreaHeightPercentage)
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                for recognizer in self.cardViewController.view.gestureRecognizers!{
                    self.cardViewController.view.removeGestureRecognizer(recognizer)
                }
                if self.cardVisible{
                    
                    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown(recognizer: )))
                    swipeGestureRecognizer.direction = .down
                    self.cardViewController.view.addGestureRecognizer(swipeGestureRecognizer)
                    
                    
                } else {
                    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeUp(recognizer: )))
                    swipeGestureRecognizer.direction = .up
                    self.cardViewController.view.addGestureRecognizer(swipeGestureRecognizer)
                    
                }
                self.runningAnimation.removeAll()
            }
            
            
            
            frameAnimator.startAnimation()
            runningAnimation.append(frameAnimator)
            
        }
    }
    
    func startInteractiveTransition(state: CardState, duration: TimeInterval){
        if runningAnimation.isEmpty{
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animation in runningAnimation {
            animation.pauseAnimation()
            animationProgressWhenInterrupted = animation.fractionComplete
            updateInteractiveTransition(fractionCompleted: animation.fractionComplete)
        }
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat){
        for animation in runningAnimation {
            animation.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition(){
        for animation in runningAnimation {
            animation.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            let point = touches.first?.location(in: self.view)
            if let layer = self.view.layer.hitTest(point!) as? CAShapeLayer{
                if ((layer.path?.contains(point!)) != nil){
                    print("Tapped")
                }
            }
        }
    }
