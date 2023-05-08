//
//  SetupProfileViewController.swift
//  ChatProject
//
//  Created by Vladimir on 14.02.2023.
//

import UIKit
import FirebaseAuth

class SetupProfileViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Setup profile!", font: .avenir26())
    let fullNameLabel = UILabel(text: "Full name", font: .avenir20())
    let aboutLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    
    let sexSegmentControl = UISegmentedControl(first: "Male", second: "Female")
    
    let goToChatsButton = UIButton(title: "Начать чат!", titleColor: .white, backgroundColor: .buttonDark(), cornerRadius: 4)
    
    private let currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let username = currentUser.displayName {
            fullNameTextField.text = username
        }
        //TODO set google image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let fullImageView = AddPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
    }
    
    @objc private func goToChatsButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImageString: "nil",
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentControl.titleForSegment(at: sexSegmentControl.selectedSegmentIndex)) { (result) in
            switch result {
                
            case .success(let muser):
                self.showAlert(with: "Успешно!", and: "Приятного общения") {
                    let mainTabBar = MainTabBarController(currentUser: muser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true)
                }
                print(muser)
            case .failure(let error):
                self.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}

//MARK: - Setup Constraints
extension SetupProfileViewController {
    private func setupConstraints() {
        
        let fillNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentControl], axis: .vertical, spacing: 8)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [fillNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(welcomeLabel)
        view.addSubview(fullImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

//MARK: - SwiftUI Preview
import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}
