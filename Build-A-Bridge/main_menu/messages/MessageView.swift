//
//  MessageView.swift
//  Build-A-Bridge
//
//  Created by Baily Troyer on 9/2/18.
//  Copyright © 2018 Build-A-Bridge-Foundation. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import JSQMessagesViewController

class MessageVIew: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //senderId = "1234"
        //senderDisplayName = "..."
        
        //
        
        let defaults = UserDefaults.standard
        
        if  let id = defaults.string(forKey: "jsq_id"),
            let name = defaults.string(forKey: "jsq_name")
        {
            senderId = id
            senderDisplayName = name
        }
        else
        {
            senderId = String(arc4random_uniform(999999))
            senderDisplayName = ""
            
            defaults.set(senderId, forKey: "jsq_id")
            defaults.synchronize()
            
            showDisplayNameDialog()
        }
        
        title = "Chat: \(senderDisplayName!)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1
        
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        //
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        let query = Constants.refs.databaseChats.child("-LJp0_IRtHaavU8JkGbn").child("messageHistory")
        // each message is the n message child [0,1,2,3]
        
        /* TODO:
         * - check that the two uids are filled when sending message
         * - check the updated time is constantly updated
        */
        
        
//        _ = query.observe(.childAdded, with: { [weak self] snapshot in
//
//            if  let data        = snapshot.value as? [String: String],
//                let id          = data["sender_id"],
//                let name        = data["name"],
//                let text        = data["text"],
//                !text.isEmpty
//            {
//                if let message = JSQMessage(senderId: id, displayName: name, text: text)
//                {
//                    self?.messages.append(message)
//
//                    self?.finishReceivingMessage()
//                }
//            }
//        })
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            let s = snapshot.value as? NSDictionary
            
            print("snapshot: \(snapshot.value as? NSDictionary)")
            print(s!["senderUid"])
            print(s!["content"])
            
            if let data = snapshot.value as? NSDictionary, let id = data["senderUid"], let text = data["content"], let name = data["senderName"]{
                
                if let message = JSQMessage(senderId: id as! String, displayName: name as! String, text: text as! String) {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
//            if let data = snapshot.value as? [String: String], let id   = data["senderUid"], let name = data["senderName"], let text = data["content"], !text.isEmpty {
//                if let message = JSQMessage(senderId: id, displayName: name, text: text) {
//                    self?.messages.append(message)
//
//                    self?.finishReceivingMessage()
//                }
//            }
        })
        
    }
    
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard
        
        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                self?.senderDisplayName = textField.text
                
                self?.title = "Chat: \(self!.senderDisplayName!)"
                
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = Constants.refs.databaseChats.childByAutoId()
        
        //find the last number child and add + 1 for the new message 
        
        let message = ["content": text, "recieverFcmToken": "", "recieverUid": "", "senderName": senderDisplayName, "senderUid": senderId, "timestamp": ""]
        
        print()
        
        /* TODO:
         * - Assure lastUpdated is updated
         * - If first message to user, check that the uid1 and uid2 are not null if uid1 is null set to current user
         
         WHAT IS UID1 AND UID2 WHAT IS THE DIFFERENCE
         
         * - APPEND TIMESTAMP TO MESSAGE
         *
        */
        
        //ref.setValue(message)
        
        finishSendingMessage()
    }
}
