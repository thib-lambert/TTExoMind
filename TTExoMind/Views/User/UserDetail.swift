//
//  UserDetail.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import UIKit

class UserDetail: UIView {

    var user: User? {
        didSet {
            self.circle.text = user?.name.first?.uppercased()
            self.nameLabel.text = user?.name
            self.usernameLabel.text = user?.username
            self.emailLabel.text = "📧 " + (user?.email ?? "")
            self.phoneLabel.text = "☎️ " + (user?.phone ?? "")
            self.websiteLabel.text = "🌐 " + (user?.website ?? "")
        }
    }

    fileprivate lazy var circle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.App.orange.cgColor
        label.backgroundColor = UIColor.App.gold
        label.textColor = .black
        label.clipsToBounds = true
        return label
    }()

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var websiteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var stackView: UIStackView = {
        let arrangedSubviews = [self.nameLabel, self.usernameLabel, self.phoneLabel, self.emailLabel, self.websiteLabel]
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 5
        stack.backgroundColor = .white
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.circle)
        self.addSubview(self.stackView)

        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.circle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.circle.widthAnchor.constraint(equalToConstant: 70),
            self.circle.heightAnchor.constraint(equalToConstant: 70),

            self.stackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            self.stackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            self.stackView.topAnchor.constraint(equalTo: self.circle.bottomAnchor, constant: 10),

            self.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor),
            self.topAnchor.constraint(equalTo: self.circle.topAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.circle.layer.cornerRadius = self.circle.bounds.height / 2
        self.stackView.layer.cornerRadius = self.stackView.bounds.height / 8
    }
}
