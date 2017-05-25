//
//  ViewController.swift
//  ToDoList
//
//  Created by Chris Peng on 3/11/17.
//  Copyright © 2017 Chris Peng. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController {

    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))

        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))

        checkIfUserIsLoggedIn()

        tableView.register(ListCell.self, forCellReuseIdentifier: cellId)

        tableView.allowsMultipleSelectionDuringEditing = true
    }

    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let uid = FIRAuth.auth()?.currentUser?.uid

        let event = self.events[indexPath.row]

        FIRDatabase.database().reference().child("user-list").child(uid!).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("Failed to delete message:", error as Any)
                return
            }
            self.attemptReloadOfTable()

        })

    }

    var timer: Timer?

    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }

    func handleReloadTable() {
        self.events = Array(self.eventsDictionary.values)
        self.events.sort(by: { (events1, events2) -> Bool in
            return events1.timestamp!.intValue > events2.timestamp!.intValue
        })

        // this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListCell
        let event = events[indexPath.row]
        cell.event = event
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let event = events[indexPath.row]
//
//        let ref = FIRDatabase.database().reference().child("users")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else {
//                return
//            }
//            let user = User()
//            user.id = chatPartnerId
//            user.setValuesForKeys(dictionary)
//            self.showList(user: user)
//        }, withCancel: nil)

        let chatLogController = DetailViewController()
        chatLogController.title = self.title
        chatLogController.event = events[indexPath.row]
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    func showList() {
        print(1)
    }

    var events = [Event]()
    var eventsDictionary = [String: Event]()

    func observeUserMessages() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        print(uid)
        let ref = FIRDatabase.database().reference().child("user-list").child(uid!)
        ref.observe(.childAdded, with: { (snapshot) in

            let eventId = snapshot.key
            self.fetchMessageWithMessageId(messageId: eventId)
        }, withCancel: nil)

        ref.observe(.childRemoved, with: { (snapshot) in
            self.eventsDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }

    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = FIRDatabase.database().reference().child("Events").child(messageId)

        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Event(dictionary: dictionary as [String : AnyObject])

                self.eventsDictionary[snapshot.key] = message

                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }

    func fetchUserAndSetupNavBarTitle() {
        let uid = FIRAuth.auth()?.currentUser?.uid

        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }

    func setupNavBarWithUser(user: User) {
        events.removeAll()
        eventsDictionary.removeAll()
        self.navigationItem.title = user.name
        attemptReloadOfTable()
        observeUserMessages()
    }


    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        print(22)
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }


}

