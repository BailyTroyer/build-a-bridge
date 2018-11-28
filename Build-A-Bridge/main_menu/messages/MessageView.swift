//
//  MessageView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 11/26/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import FirebaseAuth
import MessageInputBar
import FirebaseDatabase
import FirebaseFirestore

class MessageView: MessagesViewController {
    
    var messages: [Message] = []
    var member: Member!
    var message_id: String = ""
    var reciever_id: String = ""
    var current_message: String = ""
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in messages")
        member = Member(name: (Auth.auth().currentUser?.displayName)!, color: .blue)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.ref.child("MESSAGES").child(self.message_id).child("messageHistory").observe(.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
                if value != nil {
    
                    print("snap: \(value!)")
    
                    let usr = value?.value(forKey: "senderUid") as? String
                    let msg = value?.value(forKey: "content") as? String
                    
                    print("msg: \(msg)")
                    print("current message: \(self.current_message)")
                    
                    if self.current_message != msg {
    
                        if usr == Auth.auth().currentUser?.uid {
                            print("the message was sent from you!")
                            let mbmr = self.member
                            let newMessage = Message(
                                member: mbmr!,
                                text: msg!,
                                messageId: UUID().uuidString)
        
                            self.messages.append(newMessage)
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom(animated: true)
        
                            print("MESSAGE: \(newMessage)")
                        } else {
                            print("the message was NOT sent from you!")
                            let mbmbr_name = value?.value(forKey: "senderName") as? String
                            let mbmr = Member(name: (mbmbr_name)!, color: .red)
                            let newMessage = Message(
                                member: mbmr,
                                text: msg!,
                                messageId: UUID().uuidString)
        
                            self.messages.append(newMessage)
                            self.messagesCollectionView.reloadData()
                            self.messagesCollectionView.scrollToBottom(animated: true)
        
                            print("MESSAGE: \(newMessage)")
                        }
                    }
            
                }
            
            print("CHANGE TO DATABASE")
            print("snapshot: \(snapshot)")
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.messages = []
        
        let subRequest = self.ref.child("MESSAGES").child(self.message_id).child("messageHistory").observeSingleEvent(of: .value, with: { (snapshot) in
            
            //print("snapshot: \(snapshot)")
            let value = snapshot.value as? NSDictionary
            //print(value)
            
            if snapshot.value as? NSDictionary != nil {
                
                for message in value! {
                    let contents = message.value as? NSDictionary
                    
                    let usr = contents?.value(forKey: "senderUid") as? String
                    let msg = contents?.value(forKey: "content") as? String
                
                    if usr == Auth.auth().currentUser?.uid {
                        //print("the message was sent from you!")
                        let mbmr = self.member
                        let newMessage = Message(
                            member: mbmr!,
                            text: msg!,
                            messageId: UUID().uuidString)
                        
                        self.messages.append(newMessage)
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom(animated: true)
                        
                        //print("MESSAGE: \(newMessage)")
                    } else {
                        //print("the message was NOT sent from you!")
                        let mbmbr_name = contents?.value(forKey: "senderName") as? String
                        let mbmr = Member(name: (mbmbr_name)!, color: .red)
                        let newMessage = Message(
                            member: mbmr,
                            text: msg!,
                            messageId: UUID().uuidString)
                        
                        self.messages.append(newMessage)
                        self.messagesCollectionView.reloadData()
                        self.messagesCollectionView.scrollToBottom(animated: true)
                        
                        //print("MESSAGE: \(newMessage)")
                    }
                    
                }
                
            } else {
                print("snapshot is nil")
            }
        })
    }
}

extension MessageView: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension MessageView: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension MessageView: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {

        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        print("sending message to database")
        
        self.current_message = text
        
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute,.second,.month,.year,.day], from: Date())
        
        print("MESSAGE ID: \(self.message_id)")
        let subRequest = self.ref.child("MESSAGES").child(self.message_id).child("messageHistory").childByAutoId()
        subRequest.setValue([
            "content": newMessage.text,
            "recieverFcmToken": "TOKEN",
            "recieverUid": "UID",
            "senderName": (Auth.auth().currentUser?.displayName)!,
            "senderUid": (Auth.auth().currentUser?.uid)!,
            "timeStamp": [
                "day": time.day,
                "hour": time.hour,
                "minute": time.minute,
                "month": time.month,
                "second": time.second,
                "year": time.year
            ]
        ])

        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension MessageView: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}
