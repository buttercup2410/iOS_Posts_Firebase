//
//  PostTableViewCell.swift
//  Assignment08
//
//  Created by Mohamed Shehab on 3/13/24.
//

import UIKit
import Firebase

protocol PostDelegate {
    func deletePost(_ post: Post)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var post: Post?
    var postDelegate: PostDelegate?
    
    func configure(with post: Post) {
        self.post = post
        
        postTextLabel.text = post.postText ?? "N/A"
        ownerLabel.text = "By: \(post.createdByName ?? "Unknown")"
        
        if let createdAt = post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
            createdAtLabel.text = dateFormatter.string(from: createdAt.dateValue())
        } else {
            createdAtLabel.text = "N/A"
        }
    }
    
    func bind(postDelegate: PostDelegate, post: Post){
        self.post = post
        self.postDelegate = postDelegate
        
        if let postText = post.postText {
            postTextLabel.text = postText
        }
        if let createdByName = post.createdByName {
            ownerLabel.text = "By: \(createdByName)"
        }
        if let createdAt = post.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
            createdAtLabel.text = dateFormatter.string(from: createdAt.dateValue())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        //        if let postDelegate = self.postDelegate {
        //            postDelegate.deletePost(self.post!)
        //        }
        //        guard let post = self.post else { return }
        //
        //            // Call the delete function in the delegate to handle local deletion
        //            if let postDelegate = self.postDelegate {
        //                postDelegate.deletePost(post)
        //            }
        //
        //            // Delete the post from Firebase Firestore
        //            let db = Firestore.firestore()
        //        db.collection("posts").document(post.docID!).delete { error in
        //                if let error = error {
        //                    print("Error deleting post: \(error)")
        //                } else {
        //                    print("Post successfully deleted from Firestore")
        //
        //                }
        //            }
        //
        //    }
        //}
        guard let post = self.post else { return }
        
        if let postDelegate = self.postDelegate {
            postDelegate.deletePost(post)
        }
        
        let db = Firestore.firestore()
        db.collection("posts").document(post.docID!).delete { error in
            if let error = error {
                print("Error deleting post: \(error)")
            } else {
                print("Post successfully deleted from Firestore")
            }
        }
    }
}
