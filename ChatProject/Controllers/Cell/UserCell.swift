//
//  UserCell.swift
//  ChatProject
//
//  Created by Vladimir on 16.02.2023.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfConfiguringCell {

    let userImageView = UIImageView()
    let userName = UILabel(text: "Alexey", font: .laoSangamMN20())
    let containerView = UIView()
    
    static var reuseId = "UserCell"
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = #colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    func configure<U>(with value: U) where U: Hashable {
        guard let user: MUser = value as? MUser else {return}
        userName.text = user.username
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url)
    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
                
        NSLayoutConstraint.activate([
            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - SwiftUI Preview
import SwiftUI

struct UserChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
}

