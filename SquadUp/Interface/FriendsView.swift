//
//  FriendsView.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class FriendsView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    private var addFriendTextField: UITextField!
    
    private var addFriendButton: UIButton!
    
    private var friendList: UITableView!
    
    private var createGroupButton: UIButton!

    internal override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
        formatScreen()
        setupButtons()
        setupFriendList()
    }
    
    private func initializeViews() {
        addFriendTextField = view.viewWithTag(5) as! UITextField
        addFriendButton = view.viewWithTag(6) as! UIButton
        friendList = view.viewWithTag(7) as! UITableView
        createGroupButton = view.viewWithTag(8) as! UIButton
    }
    
    private func formatScreen() {
        addFriendButton.layer.cornerRadius = 10
        addFriendButton.clipsToBounds = true
        createGroupButton.layer.cornerRadius = 10
        createGroupButton.clipsToBounds = true
    }
    
    private func setupButtons() {
        addFriendButton.addTarget(self, action: #selector(addFriendButtonPress(_:)), for: .touchUpInside)
        createGroupButton.addTarget(self, action: #selector(createGroupButtonPress(_:)), for: .touchUpInside)
        let screenTapGesture = UITapGestureRecognizer(target: self, action: #selector(stopEditingTextField))
        view.addGestureRecognizer(screenTapGesture)
    }
    
    @objc private func addFriendButtonPress(_ sender: UIButton) {
        addFriend()
    }
    
    @objc private func createGroupButtonPress(_ sender: UIButton) {
        if isAnyFriendSelected() {
            createGroup()
        }
    }
    
    private func setupFriendList() {
        friendList.delegate = self
        friendList.dataSource = self
    }
    
    internal func viewWasSelected() {
        resetSelectedFriends()
        refreshData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.user?.friends.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "friendCell")
        if cell == nil {
            tableView.register(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "friendCell")
        }
        let friend = DataManager.user!.friends[indexPath.row]
        let friendBackground = cell!.contentView.subviews[0]
        friendBackground.alpha = friend.selected ? 1.0 : 0.0
        let friendName = cell!.contentView.subviews[1] as! UILabel
        friendName.text = friend.name
        let friendEmail = cell!.contentView.subviews[2] as! UILabel
        friendEmail.text = friend.id
        let friendButton = cell!.contentView.subviews[3] as! UIButton
        friendButton.addTarget(self, action: #selector(friendCellButtonPress(_:)), for: .touchDown)
        friendButton.tag = indexPath.row + 100
        return cell!
    }
    
    @objc private func friendCellButtonPress(_ sender: UIButton) {
        let friend = DataManager.user!.friends[sender.tag - 100]
        friend.selected = !friend.selected
        let background = sender.superview!.subviews[0]
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
            background.alpha = friend.selected ? 1.0 : 0.0
        }, completion: {
            finished in
        })
        updateCreateGroupButtonColor()
        stopEditingTextField()
    }
    
    @objc private func stopEditingTextField() {
        view.endEditing(true)
    }
    
    private func resetSelectedFriends() {
        for friend in DataManager.user!.friends {
            friend.selected = false
        }
        createGroupButton.backgroundColor = UIColor.appMediumGray
    }
    
    private func isAnyFriendSelected() -> Bool {
        for friend in DataManager.user!.friends {
            if friend.selected {
                return true
            }
        }
        return false
    }
    
    private func updateCreateGroupButtonColor() {
        if isAnyFriendSelected() {
            createGroupButton.backgroundColor = UIColor.appMediumBlue
        } else {
            createGroupButton.backgroundColor = UIColor.appMediumGray
        }
    }
    
    private func addFriend() {
        if addFriendTextField.hasText {
            BackendManager.getUserRecord(addFriendTextField.text!) {
                user in
                if let user = user {
                    BackendManager.addFriend(DataManager.user!, user)
                    self.refreshData()
                    if let token = user.registrationToken {
                        BackendManager.sendAddedAsFriendMessage(
                            to: token,
                            DataManager.user!.id, DataManager.user!.name
                        )
                    }
                } else {
                    self.view.makeToast("User does not exist", duration: 2.0, position: .bottom)
                }
            }
        } else {
            view.makeToast("Enter a user email", duration: 2.0, position: .bottom)
        }
        addFriendTextField.text = ""
        stopEditingTextField()
    }
    
    private func createGroup() {
        var selectedFriends = [User]()
        selectedFriends += [DataManager.user!]
        for friend in DataManager.user!.friends {
            if friend.selected {
                selectedFriends += [friend]
            }
        }
        let alert = UIAlertController(title: "Squad Up", message: "Enter a name for the group:", preferredStyle: .alert)
        alert.addTextField() {
            textField in
            textField.placeholder = "Enter group name"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in
            if let textFields = alert.textFields {
                let textField = textFields[0]
                if textField.hasText && textField.text!.count > 1 {
                    self.view.makeToast("Created group: \(textField.text!)", duration: 2.0, position: .bottom)
                    let createdGroup = Group(withName: textField.text!)
                    for friend in selectedFriends {
                        createdGroup.memberIDs += [friend.id]
                        createdGroup.members += [friend]
                        friend.groupIDs += [createdGroup.id]
                        friend.groups += [createdGroup]
                    }
                    
                    BackendManager.createGroupRecord(createdGroup)
                    
                    var recipients = [String]()
                    for friend in selectedFriends {
                        BackendManager.createUserRecord(friend)
                        if friend != DataManager.user! {
                            if let token = friend.registrationToken {
                                recipients += [token]
                            }
                        }
                    }
                    
                    for recipient in recipients {
                        BackendManager.sendAddedToGroupMessage(
                            to: recipient,
                            DataManager.user!.id, DataManager.user!.name,
                            createdGroup.id, createdGroup.name
                        )
                    }
                    
                    self.resetSelectedFriends()
                    self.refreshData()
                } else {
                    self.view.makeToast("Enter a name of at least 2 characters", duration: 2.0, position: .bottom)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        baseScreen.present(alert, animated: true)
    }
    
    internal func refreshData() {
        friendList.reloadData()
    }
    
}
