//
//  STTodoListViewController.swift
//  Sample ToDo
//
//  Created by Arasuvel Theerthapathy on 19/12/16.
//  Copyright © 2016 Arasuvel Theerthapathy. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import FirebaseDatabase

class Item {
    
    var ref: FIRDatabaseReference?
    var title: String?
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        
        let data = snapshot.value as! Dictionary<String, String>
        title = data["title"]! as String
    }
    
}


class STTodoListViewController: UIViewController {

    var user: FIRUser!
    var items = [Item]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    @IBOutlet weak var tableView: UITableView!
    
    func startObservingDatabase () {
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! FIRDataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            self.tableView.reloadData()
            
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
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

extension STTodoListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        startObservingDatabase()
        
        if tableView != nil {
            tableView.tableFooterView = UIView()
        }
    }
    
}

extension STTodoListViewController {
    
    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
            kAppDelegate.loginAsRootViewController()
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
    
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        let prompt = UIAlertController(title: "To Do App", message: "To Do Item", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }

}

// MARK: - Table view data source
extension STTodoListViewController: UITableViewDelegate {
    
}

extension STTodoListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TODOCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            item.ref?.removeValue()
        }
    }
    
}

extension STTodoListViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let message = "Nothing to display"
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string:message, attributes:[NSFontAttributeName: UIFont.systemFont(ofSize: 20.0)])
        return attributedString
    }
}

