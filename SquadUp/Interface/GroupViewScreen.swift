//
//  GroupViewScreen.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/17/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class GroupViewScreen: BaseScreen, UITableViewDelegate, UITableViewDataSource {
    
    private var groupNameLabel: UILabel!
    
    private var memberList: UITableView!
    
    private var meetUpButton: UIButton!
    
    internal var group: Group!

    internal override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squad Up"
        showBackButton()
        setupButtons()
        setupMemberList()
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        groupNameLabel = view.viewWithTag(1) as! UILabel
        memberList = view.viewWithTag(2) as! UITableView
        meetUpButton = view.viewWithTag(3) as! UIButton
    }
    
    internal override func screenCompatibility() {
        super.screenCompatibility()
        if UIScreen.main.screenSize == .iPhoneX {
            groupNameLabel.iPhoneXNavBarPositionCorrection()
            memberList.iPhoneXNavBarHeightCorrection()
        }
    }
    
    internal override func formatScreen() {
        super.formatScreen()
        groupNameLabel.text = group.name
        meetUpButton.layer.cornerRadius = 10
        meetUpButton.clipsToBounds = true
        meetUpButton.backgroundColor = UIColor.appMediumBlue
    }
    
    private func setupButtons() {
        meetUpButton.addTarget(self, action: #selector(meetUpButtonPress(_:)), for: .touchUpInside)
    }
    
    @objc private func meetUpButtonPress(_ sender: UIButton) {
        show(screen: MeetUpScreen.self)
    }
    
    private func setupMemberList() {
        memberList.delegate = self
        memberList.dataSource = self
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.members.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "friendCell")
        if cell == nil {
            tableView.register(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "friendCell")
        }
        let member = group.members[indexPath.row]
        let memberName = cell!.contentView.subviews[1] as! UILabel
        memberName.text = member.name
        let memberEmail = cell!.contentView.subviews[2] as! UILabel
        memberEmail.text = member.id
        return cell!
    }

}
