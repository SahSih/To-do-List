//
//  NewMessageController.swift
//  ToDoList
//
//  Created by Chris Peng on 3/11/17.
//  Copyright © 2017 Chris Peng. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UIViewController {

    var messagesController: ViewController?
    let titleLable: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.borderStyle = .line
        tf.layer.borderWidth = 3
        tf.layer.borderColor = UIColor.darkGray.cgColor
        tf.placeholder = "Event name"
        tf.textAlignment = .center
        tf.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        return tf
    }()

    let detailLable: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.backgroundColor = .white
        tv.layer.borderWidth = 3
        tv.layer.borderColor = UIColor.darkGray.cgColor
        tv.textAlignment = .left
        tv.text = "Detail"
        tv.textColor = .lightGray
        return tv
    }()

    lazy var submit: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()

    func handleSubmit() {
        var properties = [String: AnyObject]()
        sendMessageWithProperties(properties: properties)
        dismiss(animated: true, completion: nil)
    }

    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference().child("Events")
        let uid = FIRAuth.auth()?.currentUser?.uid
        let childRef = ref.childByAutoId()
        let timestamp = NSNumber(value: Int(Date().timeIntervalSince1970))
        var values: [String: AnyObject] = ["title": titleLable.text as AnyObject, "detail": detailLable.text as AnyObject, "timestamp": timestamp]
        // append properties dictionary onto values
        // key $0, value $1
        properties.forEach({values[$0] = $1})


        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }

            let userMessagesRef = FIRDatabase.database().reference().child("user-list").child(uid!)

            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = .white

        view.addSubview(titleLable)
        view.addSubview(detailLable)
        view.addSubview(submit)

        titleLable.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(200)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }

        detailLable.snp.makeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(250)
        }

        submit.snp.makeConstraints { (make) in
            make.top.equalTo(detailLable.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }

    }

    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
