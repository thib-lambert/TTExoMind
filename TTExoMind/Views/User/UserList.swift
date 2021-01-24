//
//  UserList.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 23/01/2021.
//

import Foundation
import UIKit

protocol UserListDelegate: NSObject {
    func userList(_ userList: UserList, didSelectUser: User)
}

class UserList: UITableView {
    
    weak var userDelegate: UserListDelegate?
    
    /// Liste des utilisateurs récupérés via l'appel réseau
    var users: [User] = [] {
        didSet {
            self.listFooter.text = "\(self.users.count) " + (self.users.count > 1 ? "Utilisateurs" : "Utilisateur")
            self.reloadData()
        }
    }
    
    fileprivate lazy var listFooter: UILabel = {
        let label = UILabel()
        label.text = "\(self.users.count) " + (self.users.count > 1 ? "Utilisateurs" : "Utilisateur")
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = UIColor.App.grey
        self.dataSource = self
        self.delegate = self
        self.register(UserCell.self, forCellReuseIdentifier: UserCell.reusableIdentifier)
        self.tableFooterView = self.listFooter
        self.separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Wrap content
        var frame = self.frame;
        frame.size.height = self.contentSize.height
        self.frame = frame
    }
}

extension UserList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reusableIdentifier) as? UserCell {
            cell.user = self.users[indexPath.row]
            return cell
        }
        
        return defaultCell
    }
}

extension UserList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userDelegate?.userList(self, didSelectUser: self.users[indexPath.row])
    }
}
