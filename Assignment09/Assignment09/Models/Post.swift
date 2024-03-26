//
//  File.swift
//  Assignment09
//
//  Created by Mohamed Shehab on 3/25/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

//class Post : Codable {
//
//    var postText: String?
//    var createdByName: String?
//    var createdByUid: String?
//    var createdAt: Timestamp?
//    
//    init(_ snapshot: DocumentSnapshot) {
//        if let data = snapshot.data()
//        {
//            self.postText = data["postText"] as? String
//            self.createdByName = data["createdByName"] as? String
//            self.createdByUid = data["createdByUid"] as? String
//            self.createdAt = data["createdAt"] as? Timestamp
//        }
//    }
//}
class Post: Codable {
    var docID: String?
    var postText: String?
    var createdByName: String?
    var createdByUid: String?
    var createdAt: Timestamp?
    
    init(snapshot: DocumentSnapshot) {
        self.docID = snapshot.documentID
        let data = snapshot.data() ?? [:]
        self.postText = data["postText"] as? String
        self.createdByName = data["createdByName"] as? String
        self.createdByUid = data["createdByUid"] as? String
        self.createdAt = data["createdAt"] as? Timestamp
    }
}
