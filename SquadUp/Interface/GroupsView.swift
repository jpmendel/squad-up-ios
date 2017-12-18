//
//  GroupsView.swift
//  SquadUp
//
//  Created by Jacob Mendelowitz on 12/8/17.
//  Copyright © 2017 Jacob Mendelowitz. All rights reserved.
//

import UIKit

class GroupsView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    private var groupList: UITableView!
    
    internal override func awakeFromNib() {
        super.awakeFromNib()
        setupGroupList()
    }
    
    internal override func initializeViews() {
        super.initializeViews()
        groupList = view.viewWithTag(4) as! UITableView
    }
    
    private func setupGroupList() {
        groupList.delegate = self
        groupList.dataSource = self
    }
    
    internal func viewWasSelected() {
        refreshData()
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.user?.groups.count ?? 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        if (cell == nil) {
            tableView.register(UINib(nibName: "GroupCell", bundle: nil), forCellReuseIdentifier: "groupCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        }
        let groupName = cell!.contentView.subviews[0] as! UILabel
        groupName.text = DataManager.user?.groups[indexPath.row].name ?? "Group Name"
        let groupButton = cell!.contentView.subviews[1] as! UIButton
        let groupTapGesture = UITapGestureRecognizer(target: self, action: #selector(groupCellButtonPress(_:)))
        groupButton.addGestureRecognizer(groupTapGesture)
        groupButton.tag = indexPath.row + 100
        return cell!
    }
    
    @objc private func groupCellButtonPress(_ sender: UITapGestureRecognizer) {
        let group = DataManager.user!.groups[sender.view!.tag - 100]
        BackendManager.getMemberData(for: group) {
            groupWithMembers in
            DataManager.group = groupWithMembers
            self.baseScreen.show(screen: GroupViewScreen.self) {
                destination in
                destination.group = DataManager.group!
            }
        }
    }
    
    internal func refreshData() {
        groupList.reloadData()
    }

}
