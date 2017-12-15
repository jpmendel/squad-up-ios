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
        initializeViews()
        setupGroupList()
    }
    
    private func initializeViews() {
        groupList = view.viewWithTag(4) as! UITableView
    }
    
    private func setupGroupList() {
        groupList.delegate = self
        groupList.dataSource = self
    }
    
    internal func viewWasSelected() {
        groupList.reloadData()
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
        return cell!
    }

}
