//
//  UserCell.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 22/01/2021.
//

import Foundation
import UIKit

/// Permet d'afficher une cellule contenant les données d'un User
class UserCell: UITableViewCell {

    static let reusableIdentifier = "UserCell"

    var user: User? {
        didSet {
            self.nameLabel.text = user?.name
            self.usernameLabel.text = user?.username
            self.emailLabel.text = user?.email
            self.phoneLabel.text = user?.phone
            self.websiteLabel.text = user?.website
        }
    }

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    fileprivate lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    fileprivate lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    fileprivate lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    fileprivate lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

    fileprivate lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "right-arrow")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
    }()

    fileprivate lazy var wrapper: UIView = {
        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.clipsToBounds = true
        wrap.backgroundColor = UIColor.App.gold
        return wrap
    }()

    fileprivate lazy var stackView: UIStackView = {
        let arrangedSubviews = [self.nameLabel, self.usernameLabel, self.phoneLabel, self.emailLabel, self.websiteLabel]
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = .none
        self.backgroundColor = UIColor.App.grey

        self.contentView.addSubview(self.wrapper)
        self.wrapper.addSubview(self.stackView)
        self.wrapper.addSubview(self.chevronImageView)

        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.wrapper.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.wrapper.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            self.wrapper.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.wrapper.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),

            self.stackView.topAnchor.constraint(equalTo: self.wrapper.topAnchor, constant: 10),
            self.stackView.rightAnchor.constraint(equalTo: self.wrapper.rightAnchor, constant: -40),
            self.stackView.bottomAnchor.constraint(equalTo: self.wrapper.bottomAnchor, constant: -10),
            self.stackView.leftAnchor.constraint(equalTo: self.wrapper.leftAnchor, constant: 10),

            self.chevronImageView.widthAnchor.constraint(equalToConstant: 30),
            self.chevronImageView.heightAnchor.constraint(equalToConstant: 30),
            self.chevronImageView.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor),
            self.chevronImageView.leftAnchor.constraint(equalTo: self.stackView.rightAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.wrapper.layer.cornerRadius = self.wrapper.bounds.height / 8
    }
}
