//
//  RegisterViewController.swift
//  Assignment08
//
//  Created by Mohamed Shehab on 3/13/24.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        //on successful registration call
        //SceneDelegate.showPosts()
        let name = fullnameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if name.isEmpty || email.isEmpty || password.isEmpty {
                print("Enter name/email/password")
                showAlertWith(title: "Login error", message: "Enter valid name/email/password", okAlertAction: nil)
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.showAlertWith(title: "New user creation error", message: error.localizedDescription, okAlertAction: nil)
                        return
                    }
                    
                    print("User is created!")
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print("Error updating display name: \(error.localizedDescription)")
                        } else {
                            if let displayName = Auth.auth().currentUser?.displayName {
                                print("Registered user's name: \(displayName)")
                            } else {
                                print("Registered user's name is not available")
                            }
                            SceneDelegate.showPosts()
                        }
                    }
                }
            }
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
