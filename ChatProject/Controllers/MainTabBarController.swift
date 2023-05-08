//
//  MainTabBarController.swift
//  ChatProject
//
//  Created by Vladimir on 14.02.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(username: "Test",
                                    email: "Test",
                                    avatarStringURL: "Test",
                                    description: "Test",
                                    sex: "Test",
                                    id: "Test")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        tabBar.tintColor = .systemPink
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavController(rootViewController: peopleViewController, title: "People", image: peopleImage),
            generateNavController(rootViewController: listViewController, title: "Conversation", image: convImage)
        ]
    }
    
    private func generateNavController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
