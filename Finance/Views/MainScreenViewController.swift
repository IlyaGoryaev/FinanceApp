import UIKit
import RxSwift
import RxCocoa
import RxDataSources

//Решить проблему с добалением view в стек

class ViewControllerWithView: UIViewController {
    
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
    private var viewModel = MainScreenViewModel()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            buttons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
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
        setUpButtons()
        //кнопка не работает после добавления child View Controller
        
        setUpCard()
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
        
        let panGestureRecognizerBottomToTap = UIPanGestureRecognizer(target: self, action: #selector(handleCardPanBottomToTop(recognizer: )))
                cardViewController.handleView.addGestureRecognizer(panGestureRecognizerBottomToTap)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer: )))
        cardViewController.handleView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleCardTap(recognizer: UITapGestureRecognizer){
        switch recognizer.state{
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    //Проблема с зависанием анимации
    @objc func handleCardPanBottomToTop(recognizer: UIGestureRecognizer){
        if let swipeGesture = recognizer as? UIPanGestureRecognizer{
            
            switch swipeGesture.direction{
                
            case .bottomToTop:
                
                switch recognizer.state{
                    
                case .began:
                            startInteractiveTransition(state: nextState, duration: 0.9)
                        case .changed:
                            let translation = swipeGesture.translation(in: self.cardViewController.handleView)
                            var fractionComplete = translation.y / cardHeight
                            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                            updateInteractiveTransition(fractionCompleted: fractionComplete)
                case .ended:
                    let translation = swipeGesture.translation(in: self.cardViewController.handleView)
                    var fractionComplete = translation.y / self.cardViewController.handleView.frame.height
                            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                            if fractionComplete < 0.3{
                                cardVisible = false
                                for animator in self.runningAnimation{
                                    animator.stopAnimation(false)
                                }
                                self.runningAnimation.removeAll()
                                animateTransitionIfNeeded(state: nextState, duration: 0.5)
                            }else{
                                continueInteractiveTransition()
                            }
                        default:
                            break
                        }
            default:
                break
            }
        }
    }
    

    @objc func handleCardPanTopToBottom(recognizer: UIGestureRecognizer){
        if let swipeGesture = recognizer as? UIPanGestureRecognizer{
            
            switch swipeGesture.direction{
                
            case .topToBottom:
                print(cardViewController.view.frame.minY)
                    switch recognizer.state{
                    case .began:
                        startInteractiveTransition(state: nextState, duration: 0.9)
                    case .changed:
                        let translation = swipeGesture.translation(in: self.cardViewController.handleView)
                        var fractionComplete = translation.y / cardHeight
                        fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                        updateInteractiveTransition(fractionCompleted: fractionComplete)
                    case .ended:
                        let translation = swipeGesture.translation(in: self.cardViewController.handleView)
                        var fractionComplete = translation.y / self.cardViewController.handleView.frame.height
                                fractionComplete = cardVisible ? fractionComplete : -fractionComplete
                                if fractionComplete < 0.3{
                                    cardVisible = false
                                    for animator in self.runningAnimation{
                                        animator.stopAnimation(false)
                                    }
                                    self.runningAnimation.removeAll()
                                    animateTransitionIfNeeded(state: nextState, duration: 0.5)
                                }else{
                                    continueInteractiveTransition()
                                }
                            default:
                                break
                            }
            default:
                break
            }
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
                for recognizer in self.cardViewController.handleView.gestureRecognizers!{
                    self.cardViewController.handleView.removeGestureRecognizer(recognizer)
                }
                if self.cardVisible{
                    let panGestureRecognizerTopToBottom = UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPanTopToBottom(recognizer: )))
                    self.cardViewController.handleView.addGestureRecognizer(panGestureRecognizerTopToBottom)
                } else {
                    let panGestureRecognizerBottomToTap = UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPanBottomToTop(recognizer: )))
                    self.cardViewController.handleView.addGestureRecognizer(panGestureRecognizerBottomToTap)
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
            print("Paused")
            //continueInteractiveTransition()
            animationProgressWhenInterrupted = animation.fractionComplete
            updateInteractiveTransition(fractionCompleted: animation.fractionComplete)
        }
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
