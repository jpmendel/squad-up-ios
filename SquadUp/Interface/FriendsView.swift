//
//  FriendsView.swift
//  SquadUp
//
//  Created by Jacob on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class FriendsView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    private var friendNameField: UITextField!
    
    private var addFriendButton: UIButton!
    
    private var friendList: UITableView!
    
    private var createGroupButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
        formatScreen()
        setupButtons()
        setupFriendList()
    }
    
    private func initializeViews() {
        friendNameField = view.viewWithTag(5) as! UITextField
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
    
    func viewWasSelected() {
        resetSelectedFriends()
        friendList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.user?.friends.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
    }
    
    private func createGroup() {
        baseScreen.show(screen: MeetUpScreen.self)
    }
    
}
