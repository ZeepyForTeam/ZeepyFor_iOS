//
//  loginEmailViewController.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/07/05.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import AuthenticationServices
import CryptoKit

class LoginEmailViewController: BaseViewController {
  
  let contentView = UIView()
  
  let backButton = UIButton().then{
    $0.setImage(UIImage(named: "btnBack"), for: .normal)
  }
  let viewTitle = UIImageView().then{
    $0.image = UIImage(named: "group926")
  }
  let signInTitle = UILabel().then{
    $0.text = "Sign in"
    $0.font = UIFont(name: "Gilroy-ExtraBold", size: 16.0)
  }
  let idTextFieldBackGroundView = UIView().then{
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 10)
  }
  let idTextField = UITextField().then{
    $0.placeholder = "아이디를 입력해주세요."
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
  }
  let pwTextFieldBackGroundView = UIView().then{
    $0.backgroundColor = .gray244
    $0.setRounded(radius: 10)
  }
  let pwTextField = UITextField().then{
    $0.placeholder = "비밀번호를 입력해주세요."
    $0.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
  }
  let findIDButton = UIButton().then{
    $0.setTitle("아이디찾기", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
  }
  let findPWButton = UIButton().then{
    $0.setTitle("비밀번호 찾기", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
  }
  let signUpButton = UIButton().then{
    $0.setTitle("회원가입", for: .normal)
    $0.setTitleColor(.grayText, for: .normal)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 10.0)
  }
  let loginButton = UIButton().then{
    $0.setTitle("로그인", for: .normal)
    $0.backgroundColor = .mainBlue
    $0.titleLabel?.textColor = .white
    $0.setRounded(radius: 10)
    $0.titleLabel?.font = UIFont(name: "NanumSquareRoundOTFEB", size: 15.0)
  }
  let seperateBar = UIView().then{
    $0.backgroundColor = .gray244
  }
  let snsLoginLabel = UILabel().then{
    $0.text = "SNS Login"
    $0.font = UIFont(name: "Gilroy-ExtraBold", size: 16.0)
  }
  
  let snsStackView = UIStackView()
  let appleLoginButton = UIButton().then{
    $0.setImage(UIImage(named: "logoApple"), for: .normal)
  }
  let kakaoLoginButton = UIButton().then{
    $0.setImage(UIImage(named: "logoCacao"), for: .normal)
    $0.isEnabled = true
  }
  let naverLoginButton = UIButton().then{
    $0.setImage(UIImage(named: "logoNaver"), for: .normal)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(contentView)
    addContraints()
    bind()
    signUpButton.rx.tap.bind{[weak self] in
      let vc = SignUpViewController()
      self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    //    loginButton.rx.tap.bind{ [weak self] in
    //      LoginManager.shared.makeLoginStatus(accessToken: "temp", refreshToken: "refresh")
    //      let rootNav = UINavigationController()
    //      rootNav.navigationBar.isHidden = true
    //      let rootVC = TabbarViewContorller()
    //
    //      rootNav.viewControllers = [rootVC]
    //      rootNav.modalPresentationStyle = .fullScreen
    //      self?.present(rootNav, animated: true, completion: nil)
    //
    //    }.disposed(by: disposeBag)
  }
  private let viewModel = LoginViewModel()
  func bind() {
    let input = LoginViewModel.Input(emailText: idTextField.rx.text.orEmpty.asObservable(),
                                     passwordText: pwTextField.rx.text.orEmpty.asObservable(),
                                     loginButtonDidTap: loginButton.rx.tap.asObservable(),
                                     kakaoLogin: kakaoLoginButton.rx.tap.asObservable())
    let output = viewModel.transform(inputs: input)
    output.isLoginSuccess.bind{[weak self] result in
      switch result {
      case .success(let result) :
        UserManager.shared.userId = result.userId
        LoginManager.shared.makeLoginStatus(accessToken: result.accessToken, refreshToken: result.refreshToken, loginType: .email)
        let rootNav = UINavigationController()
        rootNav.navigationBar.isHidden = true
        let rootVC = TabbarViewContorller()
        
        rootNav.viewControllers = [rootVC]
        rootNav.modalPresentationStyle = .fullScreen
        self?.present(rootNav, animated: true, completion: nil)
        
      case .failure(let errorType) :
        var errMessage : String = ""
        
        switch errorType {
        case .auth :
          errMessage = "잘못된 이메일 혹은 비밀번호입니다."
        case .notfound:
          errMessage = "존재하지 않는 계정입니다."
        case .server:
          errMessage = "서버 점검 중입니다."
        default :
          errMessage = "서버 오류가 발생했습니다."
        }
        MessageAlertView.shared.showAlertView(title: errMessage, grantMessage: "확인",okAction: {
          self?.idTextField.text = ""
          self?.pwTextField.text = ""
        })
      }
    }.disposed(by: disposeBag)
    output.socialLoginSuccess.bind{[weak self] result in
      switch result {
      case .success(let result) :
        UserManager.shared.userId = result.userId
        LoginManager.shared.makeLoginStatus(accessToken: result.accessToken, refreshToken: result.refreshToken, loginType: .kakao)
        let rootNav = UINavigationController()
        rootNav.navigationBar.isHidden = true
        let rootVC = TabbarViewContorller()
        
        rootNav.viewControllers = [rootVC]
        rootNav.modalPresentationStyle = .fullScreen
        self?.present(rootNav, animated: true, completion: nil)
        
      case .failure(let errorType) :
        var errMessage : String = ""
        
        switch errorType {
        case .auth :
          errMessage = "잘못된 이메일 혹은 비밀번호입니다."
        case .notfound:
          errMessage = "존재하지 않는 계정입니다."
        case .server:
          errMessage = "서버 점검 중입니다."
        default :
          errMessage = "서버 오류가 발생했습니다."
        }
        MessageAlertView.shared.showAlertView(title: errMessage, grantMessage: "확인",okAction: {
          self?.idTextField.text = ""
          self?.pwTextField.text = ""
        })
      }
    }.disposed(by: disposeBag)
    appleLoginButton.rx.tap.bind{ [weak self] in
      self?.appleLogin()
    }.disposed(by: disposeBag)
  }
  
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }
  fileprivate var currentNonce: String?
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()

    return hashString
  }
  private func appleLogin() {
    let nonce = randomNonceString()
//    신규발급
//    currentNonce = nonce
    currentNonce = "VXDYDK0yvviFvQeEX8XdtBmTBH9LkdIA"
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.email]
    request.nonce = sha256(currentNonce!)
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  func addContraints(){
    contentView.snp.makeConstraints{
      $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    contentView.adds([backButton,viewTitle,signInTitle,idTextFieldBackGroundView,pwTextFieldBackGroundView,findIDButton,findPWButton,signUpButton,loginButton,seperateBar,snsLoginLabel,snsStackView])
    
    backButton.snp.makeConstraints{
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalToSuperview().offset(15)
    }
    viewTitle.snp.makeConstraints{
      $0.top.equalToSuperview().offset(30)
      $0.leading.equalTo(backButton).offset(30)
      $0.height.equalTo(70)
      $0.width.equalTo(220)
    }
    
    signInTitle.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(30)
      $0.top.equalTo(viewTitle.snp.bottom).offset(100)
    }
    idTextFieldBackGroundView.addSubview(idTextField)
    idTextFieldBackGroundView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(25)
      $0.trailing.equalToSuperview().offset(-25)
      $0.top.equalTo(signInTitle.snp.bottom).offset(8)
      $0.height.equalTo(50)
    }
    idTextField.snp.makeConstraints{
      $0.center.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    pwTextFieldBackGroundView.addSubview(pwTextField)
    pwTextFieldBackGroundView.snp.makeConstraints{
      $0.leading.equalToSuperview().offset(25)
      $0.trailing.equalToSuperview().offset(-25)
      $0.top.equalTo(idTextField.snp.bottom).offset(16)
      $0.height.equalTo(50)
    }
    pwTextField.snp.makeConstraints{
      $0.center.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(10)
    }
    findPWButton.snp.makeConstraints{
      $0.centerX.equalTo(pwTextField)
      $0.top.equalTo(pwTextField.snp.bottom).offset(8)
    }
    findIDButton.snp.makeConstraints{
      $0.trailing.equalTo(findPWButton.snp.leading).offset(-15)
      $0.top.equalTo(pwTextField.snp.bottom).offset(8)
    }
    signUpButton.snp.makeConstraints{
      $0.leading.equalTo(findPWButton.snp.trailing).offset(15)
      $0.top.equalTo(pwTextField.snp.bottom).offset(8)
    }
    loginButton.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(signUpButton.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(50)
    }
    seperateBar.snp.makeConstraints{
      $0.top.equalTo(loginButton.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(5)
    }
    snsLoginLabel.snp.makeConstraints{
      $0.top.equalTo(seperateBar.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(30)
    }
    snsStackView.adds([appleLoginButton, kakaoLoginButton, naverLoginButton])
    snsStackView.snp.makeConstraints{
      $0.top.equalTo(snsLoginLabel.snp.bottom).offset(16)
      $0.height.equalTo(40)
      $0.leading.equalToSuperview().offset(125)
      $0.trailing.equalToSuperview().inset(125)
    }
    appleLoginButton.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
    }
    kakaoLoginButton.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.leading.equalTo(appleLoginButton.snp.trailing).offset(10)
      $0.width.height.equalTo(40)
    }
    naverLoginButton.snp.makeConstraints{
      $0.top.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
}
extension LoginEmailViewController : ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
extension LoginEmailViewController : ASAuthorizationControllerDelegate {
  // Apple ID 연동 성공 시
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    // Apple ID
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      guard let nonce = currentNonce else {
        print("nonce 없음")
        return
      }
      print("nonce: \(nonce)")
      // 계정 정보 가져오기
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
      let email = appleIDCredential.email
      guard let idToken = appleIDCredential.identityToken else {return}
      let tokenStr = String(data: idToken, encoding: .utf8)
      guard let code = appleIDCredential.authorizationCode else { return }
      let codeStr = String(data: code, encoding: .utf8)
      let state = appleIDCredential.state
      print("User ID : \(userIdentifier)")
      print("token: \(tokenStr)")
      print("refresh: \(codeStr)")
      print("state: \(state)")
      
      
    default:
      break
    }
  }
  
  // Apple ID 연동 실패 시
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    
  }
}
