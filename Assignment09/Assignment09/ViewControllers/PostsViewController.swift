//
//  PostsViewController.swift
//  Assignment08
//
//  Created by Mohamed Shehab on 3/13/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class PostsViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var userName: String?
    var db: Firestore!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        
        if let currentUser = Auth.auth().currentUser {
                let greeting = currentUser.displayName != nil ? "Welcome \(currentUser.displayName!)" : "Hello"
                self.welcomeLabel.text = greeting
            } else {
                self.welcomeLabel.text = "Welcome user!"
            }
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        fetchPosts()
        
        self.tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosts), name: NSNotification.Name(rawValue: "reloadPosts"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewPost(_:)), name: NSNotification.Name(rawValue: "NewPostCreated"), object: nil)
        
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            SceneDelegate.showLogin()
        }
        catch let signOutError as NSError{
            print ("Error signing out: %@", signOutError)
        }
    }
    @objc func reloadPosts() {
        
    }
    @objc func handleNewPost(_ notification: Notification) {
        if let userInfo = notification.userInfo, let newPost = userInfo["post"] as? Post {
            self.posts.append(newPost)
            
            tableView.reloadData()
        }
    }
    func fetchPosts() {
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.posts.removeAll()
                for document in snapshot!.documents {
                    let postData = document.data()
                    let post = Post(snapshot: document)
                    self.posts.append(post)
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension PostsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        let post = self.posts[indexPath.row]
        
        cell.bind(postDelegate: self, post: post)
        
        cell.postTextLabel.text = post.postText ?? "No text"
        cell.ownerLabel.text = post.createdByName ?? "Unknown"
        
        
        if let createdAt = post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
            cell.createdAtLabel.text = dateFormatter.string(from: createdAt.dateValue())
        } else {
            cell.createdAtLabel.text = "N/A"
        }
        
        
        if let currentUser = Auth.auth().currentUser, post.createdByUid == currentUser.uid {
            cell.deleteButton.isHidden = false
        } else {
            cell.deleteButton.isHidden = true
        }
        return cell
    }
}

extension PostsViewController: PostDelegate {
    func deletePost(_ post: Post) {
        guard let currentUser = Auth.auth().currentUser else {
            print("No user logged in!")
            return
        }
//        showAlertWith(title: "Delete", message: "Are you sure you want to delete this post: \(post.postText!) ?", okAlertAction: nil)
        if post.createdByUid == currentUser.uid {
            showAlertWith(title: "Delete", message: "Are you sure you want to delete this post: \(post.postText!) ?", deleteAlertAction: { action in
                let postRef = self.db.collection("posts").document(post.docID!)
                postRef.delete { error in
                    if let error = error {
                        print("Error deleting post: \(error.localizedDescription)")
                    } else {
                        print("Post deleted successfully.")
                        // Remove the deleted post from the data source
                        if let index = self.posts.firstIndex(where: { $0.docID == post.docID }) {
                            self.posts.remove(at: index)
                            // Reload the table view on the main thread
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }, cancelAlertAction: nil)
        } else {
            print("You are not authorized to delete this post.")
        }
    }
}


