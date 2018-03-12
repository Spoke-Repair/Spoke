//
//  CustomerChatVC.swift
//  ParseStarterProject-Swift
//
//  Created by Tim Gianitsos on 3/11/18.
//  Copyright © 2018 Parse. All rights reserved.
//

import UIKit

class CustomerChatVC: UICollectionViewController {
    let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    let inputTextField: UITextField = {
        let inputTextField = UITextField()
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.placeholder = "Enter message..."
        return inputTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Chat"
        self.collectionView?.backgroundColor = UIColor.white
        self.setupInputComponents()
    }
    
    func setupInputComponents() {
        self.view.addSubview(self.containerView)
        self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.addTarget(self, action: #selector(CustomerChatVC.send), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        self.containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: self.containerView.heightAnchor).isActive = true
        
        self.containerView.addSubview(self.inputTextField)
        self.inputTextField.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: sendButton.heightAnchor).isActive = true
        
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor.gray
        self.containerView.addSubview(separator)
        separator.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        separator.widthAnchor.constraint(equalTo: self.containerView.widthAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @objc func send() {
        print("Send message to Firebase...")
    }
}
