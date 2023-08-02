import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//Решить проблему с добалением view в стек

class CostSreen: UIViewController {
    
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
    
    var arrayOfCategoriesSection = [Double]()
    
    let disposeBag = DisposeBag()
    
    //MARK: Тестовые кнопки
    let buttons = ButtonsStackView()
    
    //MARK: Инициализация viewModel
    private var viewModel = CostScreenViewModel()
    
    //MARK: Контроллер вида, который находится в нижнем View
    var cardViewController: CardViewController!
    
    //MARK: Визуальные эффекты, которые
    var visualEffectView: UIVisualEffectView!
    
    //MARK: Высота контролллера в двух режимах
    let cardHeight: CGFloat = 800//переделать
    let cardHandleAreaHeight: CGFloat = 300// переделать
    
    //MARK: Свойства, которые отвечает за состояние вида
    var cardVisible = false
    var nextState: CardState{
        return cardVisible ? .collapsed : .expand
    }
    
    //MARK: Виды анимаций, которые запускает UIViewPropertyAnimator
    var runningAnimation = [UIViewPropertyAnimator]()
    
    
    var animationProgressWhenInterrupted: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        viewModel.getCircleDay()
        self.cardViewController.viewModel.getDayStatistics()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        addButton.setTitleColor(.white, for: .normal)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: viewWithCircleContainer.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: viewWithCircleContainer.bottomAnchor)
        ])
        addButton.backgroundColor = .blue
        addButton.layer.cornerRadius = 16
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
            viewWithCircleContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -cardHandleAreaHeight - 50),
            viewWithCircleContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewWithCircleContainer.heightAnchor.constraint(equalToConstant: 300),
            viewWithCircleContainer.widthAnchor.constraint(equalToConstant: 300)
            
        ])
        viewWithCircleContainer.backgroundColor = .white
        
        //MARK: Добавление слоев круговой диаграммы
        for layer in CircleCategories().getCategoriesLayer(percentArray: arrayOfCategoriesSection){
            viewWithCircleContainer.layer.addSublayer(layer)
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
    
    
    @objc func addMenu(){
        let controller = UINavigationController()
        controller.modalPresentationStyle = .fullScreen
        controller.viewControllers = [CostViewController()]
        present(controller, animated: true)
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
        buttons.buttonDay.addAction(UIAction(handler: { _ in
            self.cardViewController.viewModel.getDayStatistics()
            self.viewModel.getDayLabelText()
            self.viewModel.getCircleDay()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories().getCategoriesLayer(percentArray: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
            }
        }), for:  .touchUpInside)

        buttons.buttonMonth.addAction(UIAction(handler: { _ in
            self.cardViewController.viewModel.getMonthStatistics()//Убрать
            self.viewModel.getMonthLabelText()
            self.viewModel.getCircleMonth()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories().getCategoriesLayer(percentArray: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
            }
        }), for: .touchUpInside)

        buttons.buttonYear.addAction(UIAction(handler: { _ in
            self.cardViewController.viewModel.getYearStatistics()
            self.viewModel.getYearLabelText()
            self.viewModel.getCircleYear()
            self.viewWithCircleContainer.layer.sublayers?.forEach({
                $0.isHidden = true
            })
            self.label.isHidden = false
            self.subLabel.isHidden = false
            for layer in CircleCategories().getCategoriesLayer(percentArray: self.arrayOfCategoriesSection){
                self.viewWithCircleContainer.layer.addSublayer(layer)
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
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.frame.width, height: self.cardHeight)
        cardViewController.view.clipsToBounds = true
        self.cardViewController.view.layer.cornerRadius = 20
        cardViewController.view.layer.masksToBounds = false
        
        cardViewController.view.layer.shadowRadius = 20
        cardViewController.view.layer.shadowColor = UIColor.black.cgColor
        cardViewController.view.layer.shadowPath = UIBezierPath(roundedRect: cardViewController.view.bounds, cornerRadius: cardViewController.view.layer.cornerRadius).cgPath
        cardViewController.view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cardViewController.view.layer.shadowOpacity = 0.15
        
//        let panGestureRecognizerBottomToTap = UIPanGestureRecognizer(target: self, action: #selector(handleCardPanBottomToTop(recognizer: )))
//                cardViewController.handleView.addGestureRecognizer(panGestureRecognizerBottomToTap)
//
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer: )))
//        cardViewController.handleView.addGestureRecognizer(tapGestureRecognizer)
        
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
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
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
}
