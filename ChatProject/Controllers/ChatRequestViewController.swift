//
//  ChatRequestViewController.swift
//  ChatProject
//
//  Created by Vladimir on 17.02.2023.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human5"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Tyler Durden", font: .systemFont(ofSize: 26, weight: .light))
    let aboutMeLabel = UILabel(text: "Почему все вокруг путают нас с тобой? 😵", font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", titleColor: .white, backgroundColor: .black, font: .laoSangamMN20(), isShadow: false, cornerRadius: 20)
    let denyButton = UIButton(title: "DENY", titleColor: #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1), backgroundColor: .white, font: .laoSangamMN20(), cornerRadius: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainWhite()
        customizeElements()
        setupConstraints()
    }
    
    private func customizeElements() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8756850362, green: 0.2895075083, blue: 0.2576965988, alpha: 1)
        containerView.backgroundColor = .mainWhite()
        containerView.layer.cornerRadius = 30
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        acceptButton.applyGradients(cornerRadius: 20)
    }
}

extension ChatRequestViewController {
    private func setupConstraints() {
        
        view.addSubview(imageView)
        view.addSubview(containerView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(acceptButton)
        containerView.addSubview(denyButton)
        
        let buttonstackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 7)
        buttonstackView.translatesAutoresizingMaskIntoConstraints = false
        buttonstackView.distribution = .fillEqually
        buttonstackView.spacing = 20
        containerView.addSubview(buttonstackView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 206)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
        ])
        NSLayoutConstraint.activate([
            buttonstackView.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 30),
            buttonstackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonstackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonstackView.heightAnchor.constraint(equalToConstant: 56)

        ])
    }
}
//MARK: - SwiftUI Preview
import SwiftUI

struct hatRequestVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = ChatRequestViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

