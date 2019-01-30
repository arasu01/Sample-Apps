//
//  STSignUpViewController.swift
//  Sample ToDo
//
//  Created by Arasuvel Theerthapathy on 29/11/16.
//  Copyright © 2016 Arasuvel Theerthapathy. All rights reserved.
//

import UIKit
import FirebaseAuth

class STSignUpViewController: UITableViewController {

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Signup"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Action methods
    
    @IBAction func signupButtonPressed(_ sender: AnyObject) {
        let email = emailIdTextField.text
        let password = passwordTextField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            
            
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.firstNameTextField.text! + self.lastNameTextField.text!
            changeRequest?.commitChanges() { (error) in
                // ...
            }
            
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    @IBAction func nextToolBarButtonPressed() {
        if passwordTextField.isFirstResponder == true {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            // Do nothing
        }
    }
    
    @IBAction func doneToolBarButtonPressed() {
        confirmPasswordTextField.resignFirstResponder()
        signupButtonPressed(signupButton)
    }
    

    // MARK: - Custom methods
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailIdTextField.becomeFirstResponder()
        } else if textField == emailIdTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
            signupButtonPressed(signupButton)
        } else {
            // Do nothing
        }
        return true
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
