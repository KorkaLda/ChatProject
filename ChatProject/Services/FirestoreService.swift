//
//  FirestoreService.swift
//  ChatProject
//
//  Created by Vladimir on 06.05.2023.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    var currentUser: MUser!
    
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> ()) {
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMUser))
                    return 
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        guard Validators.isFilled(username: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != UIImage(systemName: "person.crop.circle") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = MUser(username: username!,
                          email: email,
                          avatarStringURL: "not exits",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        StorageService.shared.upload(photo: avatarImage!) { result in
            switch result {
                
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                
                self.usersRef.document(muser.id).setData(muser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result <Void, Error>) -> ()) {
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        let chat = MChat(friendUsername: currentUser.username, friendAvatarImageString: currentUser.avatarStringURL, lastMessageContent: message.content, friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
}
