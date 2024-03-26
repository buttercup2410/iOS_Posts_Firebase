//
//  CreatePostViewController.swift
//  Assignment08
//
//  Created by Mohamed Shehab on 3/13/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postTextField: UITextField!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func submitClicked(_ sender: Any) {
        
        guard let postText = postTextField.text, !postText.isEmpty else {
                    showAlertWith(title: "Post Error", message: "Post text is required!", okAlertAction: nil)
                    return
                }
        
        guard let currentUser = Auth.auth().currentUser else {
            showAlertWith(title: "Error", message: "No logged-in user", okAlertAction: nil)
            return
        }

        let createdBy = currentUser.displayName ?? "Unknown"
        let db = Firestore.firestore()
        let dbRef = db.collection("posts").document()
        let data : [String : Any] = [
            "postText" : postText,
            "createdAt": FieldValue.serverTimestamp(),
            "createdByName" : currentUser.displayName,
            "createdByUid": currentUser.uid ]
        
        print("Attempting to store data at: \(dbRef.documentID)")
        dbRef.setData(data) { error in
            if error == nil{
                print("success: \(dbRef.documentID)")
                SceneDelegate.showPosts()
                print("------------------    \(data)")
            }
            else
            {
                print(error?.localizedDescription)
            }
        }

        db.collection("posts").getDocuments { snapshot, error in
            if snapshot != nil && !snapshot!.isEmpty {
                
                for doc in snapshot!.documents {
                    if let post = try? doc.data(as: Post.self) {
                        //let post = Post(doc)
                        self.posts.append(post)
                    }
                }
            }
        }
            
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewPostCreated"), object: nil, userInfo: ["data": data])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewPostCreated"), object: nil, userInfo: ["post": data])
        }
        
    @IBAction func cancelClicked(_ sender: Any) {
            self.dismiss(animated: true)
        }
    }

