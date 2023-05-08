//
//  PeopleViewController.swift
//  ChatProject
//
//  Created by Vladimir on 14.02.2023.
//

import UIKit
import FirebaseAuth

class PeopleViewController: UIViewController {
    
//    let users = Bundle.main.decode([MUser].self, from: "users.json")
    let users = [MUser]()
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>!
    
    enum Section: Int, CaseIterable {
        case users
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData(with: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc private func signOut() {
        let ac = UIAlertController(title: nil, message: "Sign Out?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Sign out", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            } catch {
                print(error.localizedDescription)
            }
        }))
        present(ac, animated: true)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)

    }
    
    private func setupSearchBar() {
        
        navigationController?.navigationBar.barTintColor = .mainWhite()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func reloadData(with searchText: String?) {
        
        let filtered = users.filter { user -> Bool in
            user.contains(filter: searchText)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, MUser>()
        
        snapshot.appendSections([.users])
        snapshot.appendItems(filtered, toSection: .users)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension PeopleViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MUser>(collectionView: collectionView, cellProvider: { collectionView, indexPath, user in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, IndexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: IndexPath) as? SectionHeader else {fatalError("Cannot create new section header")}
            
            guard let section = Section(rawValue: IndexPath.section) else {fatalError("Unknown section kind")}
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items.count),
                                    font: .systemFont(ofSize: 36, weight: .light),
                                    textColor:.label)
            return sectionHeader
        }
    }
}

extension PeopleViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment)
            -> NSCollectionLayoutSection? in
            //section -> groups -> items -> size
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {

            case .users:
                return self.createUsersSection()
            }
            
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                               heightDimension: .fractionalWidth(0.6))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
//        group.
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 15, bottom: 0, trailing: 15 - spacing)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        return sectionHeader
    }
}


//MARK: - UiSearchBarDelegate
extension PeopleViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}

//MARK: - SwiftUI Preview
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
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

