//
//  BackendManager.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import Foundation
import Firebase

class BackendManager {
    
    static let messagingServerURL = "https://fcm.googleapis.com/fcm/send"
    
    static let userCollection = "users"
    
    static let groupCollection = "groups"
    
    static let userList = "user_list"
    
    static let firestoreDatabase = Firestore.firestore()
    
    private static func sendPostRequest(to address: String, with data: [String: Any], callback: @escaping ([String: Any]?) -> Void) {
        if let url = URL(string: address) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            } catch {
                print("[BackendManager] Error parsing post data.")
                return
            }
            URLSession.shared.dataTask(with: request) {
                data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    callback(res)
                } catch {
                    print("[BackendManager] Error parsing response.")
                    callback(nil)
                }
            }.resume()
        }
    }
    
    static func startListening(to topic: String) {
        Messaging.messaging().subscribe(toTopic: topic)
    }
    
    static func stopListening(to topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic)
    }
    
    static func sendLoginMessage(to topic: String, _ senderID: String, _ senderName: String, _ latitude: Double, _ longitude: Double) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = "/topics/" + topic
        var data = [String: Any]()
        data["type"] = FirebaseMessage.login
        data["senderID"] = senderID
        data["senderName"] = senderName
        data["latitude"] = latitude
        data["longitude"] = longitude
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendLocationMessage(to topic: String, _ senderID: String, _ senderName: String, _ latitude: Double, _ longitude: Double) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = "/topics/" + topic
        var data = [String: Any]()
        data["type"] = FirebaseMessage.location
        data["senderID"] = senderID
        data["senderName"] = senderName
        data["latitude"] = latitude
        data["longitude"] = longitude
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendReadyRequestMessage(to topic: String, _ senderID: String, _ senderName: String) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = "/topics/" + topic
        var data = [String: Any]()
        data["type"] = FirebaseMessage.readyRequest
        data["senderID"] = senderID
        data["senderName"] = senderName
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendReadyResponseMessage(to topic: String, _ senderID: String, _ senderName: String, _ receiverID: String, _ readyResponse: Bool) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = "/topics/" + topic
        var data = [String: Any]()
        data["type"] = FirebaseMessage.readyResponse
        data["senderID"] = senderID
        data["senderName"] = senderName
        data["receiverID"] = receiverID
        data["readyResponse"] = readyResponse
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendReadyDecisionMessage(to topic: String, _ senderID: String, _ senderName: String, _ decision: Bool) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = "/topics/" + topic
        var data = [String: Any]()
        data["type"] = FirebaseMessage.readyDecision
        data["senderID"] = senderID
        data["senderName"] = senderName
        data["decision"] = decision
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendAddedAsFriendMessage(to recipient: String, _ senderID: String, _ senderName: String) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = recipient
        var data = [String: Any]()
        data["type"] = FirebaseMessage.addedAsFriend
        data["senderID"] = senderID
        data["senderName"] = senderName
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }

    static func sendRemovedAsFriendMessage(to recipient: String, _ senderID: String, _ senderName: String) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = recipient
        var data = [String: Any]()
        data["type"] = FirebaseMessage.removedAsFriend
        data["senderID"] = senderID
        data["senderName"] = senderName
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    static func sendAddedToGroupMessage(to recipient: String, _ senderID: String, _ senderName: String, _ groupID: String, _ groupName: String) {
        var json = [String: Any]()
        json["token"] = Messaging.messaging().fcmToken
        json["to"] = recipient
        var data = [String: Any]()
        data["type"] = FirebaseMessage.addedToGroup
        data["senderID"] = senderID
        data["senderName"] = senderName
        data["groupID"] = groupID
        data["groupName"] = groupName
        json["data"] = data
        sendPostRequest(to: messagingServerURL, with: json) {
            response in
            if let res = response {
                print("[BackendManager] Response: \(res)")
            } else {
                print("[BackendManager] Error")
            }
        }
    }
    
    private static func buildDocumentFromUser(_ user: User) -> [String: Any] {
        var userData = [String: Any]()
        userData["id"] = user.id
        userData["name"] = user.name
        userData["friendIDs"] = user.friendIDs
        userData["groupIDs"] = user.groupIDs
        userData["registrationToken"] = user.registrationToken
        return userData
    }
    
    private static func buildUserFromDocument(_ document: [String: Any]) -> User {
        let id = document["id"] as! String
        let name = document["name"] as! String
        let user = User(id, name)
        user.friendIDs = document["friendIDs"] as! [String]
        user.groupIDs = document["groupIDs"] as! [String]
        user.registrationToken = document["registrationToken"] as! String?
        return user
    }
    
    static func createUserRecord(_ user: User, callback: (() -> Void)? = nil) {
        firestoreDatabase.collection(userCollection).document(user.id)
            .setData(buildDocumentFromUser(user)) {
                error in
                if let err = error {
                    print("[BackendManager] Failed to Create User: \(err)")
                } else {
                    print("[BackendManager] Successfully Created User: \(user.id)")
                }
                if callback != nil {
                    callback!()
                }
            }
    }
    
    static func deleteUserRecord(_ userID: String, callback: (() -> Void)? = nil) {
        firestoreDatabase.collection(userCollection).document(userID)
            .delete() {
                error in
                if let err = error {
                    print("[BackendManager] Failed to Delete User: \(err)")
                } else {
                    print("[BackendManager] Successfully Deleted User: \(userID)")
                }
                if callback != nil {
                    callback!()
                }
            }
    }
    
    static func getUserRecord(_ userID: String, callback: @escaping (User?) -> Void) {
        firestoreDatabase.collection(userCollection).document(userID)
            .getDocument() {
                document, error in
                guard let document = document, error == nil else {
                    callback(nil)
                    return
                }
                if document.exists {
                    callback(buildUserFromDocument(document.data()))
                } else {
                    callback(nil)
                }
            }
    }
    
    private static func buildDocumentFromGroup(_ group: Group) -> [String: Any] {
        var groupData = [String: Any]()
        groupData["id"] = group.id
        groupData["name"] = group.name
        groupData["memberIDs"] = group.memberIDs
        return groupData
    }
    
    private static func buildGroupFromDocument(_ document: [String: Any]) -> Group {
        let id = document["id"] as! String
        let name = document["name"] as! String
        let group = Group(id, name)
        group.memberIDs = document["memberIDs"] as! [String]
        return group
    }
    
    static func createGroupRecord(_ group: Group, callback: (() -> Void)? = nil) {
        firestoreDatabase.collection(groupCollection).document(group.id)
            .setData(buildDocumentFromGroup(group)) {
                error in
                if let err = error {
                    print("[BackendManager] Failed to Create Group: \(err)")
                } else {
                    print("[BackendManager] Successfully Created Group: \(group.id)")
                }
                if callback != nil {
                    callback!()
                }
        }
    }
    
    static func deleteGroupRecord(_ groupID: String, callback: (() -> Void)? = nil) {
        firestoreDatabase.collection(groupCollection).document(groupID)
            .delete() {
                error in
                if let err = error {
                    print("[BackendManager] Failed to Delete Group: \(err)")
                } else {
                    print("[BackendManager] Successfully Deleted Group: \(groupID)")
                }
                if callback != nil {
                    callback!()
                }
        }
    }
    
    static func getGroupRecord(_ userID: String, callback: @escaping (Group?) -> Void) {
        firestoreDatabase.collection(groupCollection).document(userID)
            .getDocument() {
                document, error in
                guard let document = document, error == nil else {
                    callback(nil)
                    return
                }
                if document.exists {
                    callback(buildGroupFromDocument(document.data()))
                } else {
                    callback(nil)
                }
        }
    }
    
    static func getFriendData(for user: User, callback: ((User) -> Void)? = nil) {
        var friendList = [User]()
        if user.friendIDs.isEmpty {
            user.friends = friendList
            if let callback = callback {
                callback(user)
            }
        }
        for i in 0..<user.friendIDs.count {
            getUserRecord(user.friendIDs[i]) {
                loadedUser in
                if let loadedUser = loadedUser {
                    friendList += [loadedUser]
                }
                if i == user.friendIDs.count - 1 {
                    user.friends = friendList
                    if let callback = callback {
                        callback(user)
                    }
                }
            }
        }
    }
    
    static func getGroupData(for user: User, callback: ((User) -> Void)? = nil) {
        var groupList = [Group]()
        if user.groupIDs.isEmpty {
            user.groups = groupList
            if let callback = callback {
                callback(user)
            }
        }
        for i in 0..<user.groupIDs.count {
            getGroupRecord(user.groupIDs[i]) {
                loadedGroup in
                if let loadedGroup = loadedGroup {
                    groupList += [loadedGroup]
                }
                if i == user.groupIDs.count - 1 {
                    user.groups = groupList
                    if let callback = callback {
                        callback(user)
                    }
                }
            }
        }
    }
    
    static func addFriend(_ user1: User, _ user2: User) {
        if !user1.friendIDs.contains(user2.id) {
            user1.friendIDs += [user2.id]
            user1.friends += [user2]
            createUserRecord(user1)
        }
        if !user2.friendIDs.contains(user1.id) {
            user2.friendIDs += [user1.id]
            user2.friends += [user1]
            createUserRecord(user2)
        }
    }
    
    static func unfriend(_ user1: User, _ user2: User) {
        if user1.friendIDs.contains(user2.id) {
            user1.friendIDs.remove(object: user2.id)
            user1.friends.remove(object: user2)
            createUserRecord(user1)
        }
        if user2.friendIDs.contains(user1.id) {
            user2.friendIDs.remove(object: user1.id)
            user2.friends.remove(object: user1)
            createUserRecord(user2)
        }
    }
    
}
