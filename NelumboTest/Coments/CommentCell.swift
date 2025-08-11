//
//  CommentCell.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class CommentCell: UITableViewCell {
    static let reuseID = "CommentCell"

    private let card = UIView()
    private let authorLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 8
        card.layer.shadowOffset = .init(width: 0, height: 4)

        authorLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        authorLabel.textColor = .secondaryLabel

        messageLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .label

        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.textColor = .systemBlue
        dateLabel.textAlignment = .right

        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        let v = UIStackView(arrangedSubviews: [authorLabel, messageLabel, dateLabel])
        v.axis = .vertical
        v.spacing = 8
        card.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
    }

    func configure(author: String, message: String, dateText: String) {
        authorLabel.text = author.isEmpty ? "—" : author
        messageLabel.text = message.isEmpty ? "—" : message
        dateLabel.text = dateText
    }



    required init?(coder: NSCoder) { fatalError() }
}
