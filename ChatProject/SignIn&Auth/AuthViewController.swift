//
//  ViewController.swift
//  ChatProject
//
//  Created by Vladimir on 13.02.2023.
//

import UIKit
import GoogleSignIn
import Firebase

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(named: "logo"), contentMode: .scaleAspectFit)
    
    let appLabel = UILabel(text: "iChat - the fastest chat")
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign with")
    let alreadyOnBoardLabel = UILabel(text: "Already on board")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white,  isShadow: true)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: .buttonDark())
    let loginButton = UIButton(title: "Войти", titleColor: .buttonRed(), backgroundColor: .white,isShadow: true)
    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleButton.customizedGoogleButton()
        view.backgroundColor = .white
        setupConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(setupGoogle), for: .touchUpInside)
        
        signUpVC.delegate = self
        loginVC.delegate = self
//        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @objc private func emailButtonTapped() {
        print(#function)
        present(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        print(#function)
        present(loginVC, animated: true)
    }
}

//MARK: - Setup Constraints
extension AuthViewController {
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.font = .avenir26()
        
        
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnBoardLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 40
        
        view.addSubview(logoImageView)
        view.addSubview(appLabel)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            appLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 10),
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        

    }
}

extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginVC, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true)
    }
    
    
}

extension AuthViewController {
    
    @objc func setupGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        guard let rootViewController = window?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                self.showAlert(with: "Error", and: error.localizedDescription)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                switch result {
                    
                case .none:
                    
                    let mainTabBar = SetupProfileViewController(currentUser: result!.user)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true)
                case .some(_):
                    let muser = MUser(username: result!.user.displayName!, email: result!.user.email!, avatarStringURL: result!.user.photoURL?.absoluteString ?? "nil", description: result!.user.description, sex: "Nil", id: result!.user.uid)
                    let mainTabBar = MainTabBarController(currentUser: muser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true)
                    
                }
            }
//            guard result != nil else {
//                self.showAlert(with: "Ошибка", and: error?.localizedDescription ?? "")
//                return
//            }
        }}
}


//MARK: - SwiftUI Preview
import SwiftUI

struct AuthVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
