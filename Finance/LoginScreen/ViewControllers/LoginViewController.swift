import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources

class LoginViewController: UIViewController {
    
    let exitButton = UIButton()
    let synchronizationLabel = UILabel()
    let regButton = UIButton()
    let informationLabel = UILabel()
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let imageView = UIImageView()
    
    let segmentControl = UISegmentedControl(items: ["Регистрация", "Вход"])
    
    let disposeBag = DisposeBag()
    
    let viewModel = LoginViewModel()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    lazy var contentSize: CGSize = {
        CGSize(width: view.frame.width, height: view.frame.height)
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(82)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        setupStackView()
        
        
        setupExitButton()
        setupSynchronizationLabel()
        setupSegmentControl()
        setupImageView()
        setupInformationLabel()
        setupTextField()
        setupRegButton()
    }
    
    private func setupExitButton(){
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
        exitButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        exitButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true)
        }), for: .touchUpInside)
    }
    
    private func setupSynchronizationLabel(){
        view.addSubview(synchronizationLabel)
        synchronizationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(exitButton.snp.centerY)
        }
        synchronizationLabel.text = "Синхронизация"
        synchronizationLabel.font = .boldSystemFont(ofSize: 30)
        synchronizationLabel.textColor = .gray
    }
    
    private func setupStackView(){
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    private func setupSegmentControl(){
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
        segmentControl.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.9999921918, blue: 0.3256074786, alpha: 1)
        
        let titleTextAttributesForNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributesForNormal, for: .normal)
        let titleTextAttributesForSelected = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)]
        segmentControl.setTitleTextAttributes(titleTextAttributesForSelected, for: .selected)
        
        stackView.addArrangedSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 50)
            make.height.equalTo(35)
        }
        segmentControl.addTarget(self, action: #selector(changeValue(sender: )), for: .valueChanged)
    }
    
    @objc func changeValue(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            print("Регистрация")
            informationLabel.isHidden = false
            regButton.setTitle("Зарегистрироваться", for: .normal)
            self.viewModel.buttonMode.on(.next(0))
            break
        case 1:
            print("Вход")
            informationLabel.isHidden = true
            regButton.setTitle("Войти", for: .normal)
            self.viewModel.buttonMode.on(.next(1))
            break
        default:
            break
        }
    }
    
    private func setupTextField(){
        emailTextField.placeholder = "Email"
        emailTextField.textAlignment = .center
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.gray.cgColor
        emailTextField.layer.borderWidth = 2
        stackView.addArrangedSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 50)
            make.height.equalTo(50)
        }
        stackView.setCustomSpacing(40, after: segmentControl)
        
        passwordTextField.placeholder = "Пароль"
        passwordTextField.textAlignment = .center
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.isSecureTextEntry = true
        stackView.addArrangedSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 50)
            make.height.equalTo(50)
        }
        emailTextField.rx.text.subscribe {
            self.viewModel.email.on(.next($0!))
            print(RegDataValidation.regEmailValidate(email: $0!))
            self.viewModel.getButtonStatus()
        }.disposed(by: disposeBag)
        
        passwordTextField.rx.text.subscribe {
            self.viewModel.password.on(.next($0!))
            print(RegDataValidation.regPasswordValidate(password: $0!))
            self.viewModel.getButtonStatus()
        }.disposed(by: disposeBag)
        
    }
    
    private func setupRegButton(){
        regButton.isEnabled = false
        viewModel.isRegButtonAvailable.subscribe {
            if $0{
                self.regButton.isEnabled = true
                self.regButton.backgroundColor = #colorLiteral(red: 0.1716541946, green: 0.1766330898, blue: 0.1461265981, alpha: 1)
                self.regButton.setTitleColor(.white, for: .normal)
            } else {
                self.regButton.isEnabled = false
                self.regButton.backgroundColor = .systemGray4
                self.regButton.setTitleColor(.gray, for: .normal)
            }
        }.disposed(by: disposeBag)
        regButton.addAction(UIAction(handler: { _ in
            self.viewModel.tappedButton()
            if self.viewModel.loginStatus(){
                self.dismiss(animated: true)
            }
        }), for: .touchUpInside)
        regButton.backgroundColor = .systemGray4
        regButton.setTitleColor(.gray, for: .normal)
        regButton.layer.cornerRadius = 10
        regButton.setTitle("Зарегистрироваться", for: .normal)
        regButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        regButton.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 50)
            make.height.equalTo(50)
        }
        stackView.addArrangedSubview(regButton)
    }
    
    private func setupImageView(){
        imageView.image = UIImage(named: "Sync")
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    private func setupInformationLabel(){
        informationLabel.text = "Зарегистрируйтесь, чтобы данные синхронизировались на разных устройствах"
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .label
        informationLabel.font = .systemFont(ofSize: 15)
        stackView.addArrangedSubview(informationLabel)
        informationLabel.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width - 50)
            make.left.equalToSuperview().inset(25)
        }
        
    }
}
