//
//  ActionRowView.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class ActionRowView: UIControl {

    enum Accessory: Equatable { case chevron, none, system(String) }

    private let card = UIView()
    private let iconCircle = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()
    private let chevronView = UIImageView()

    private var rowAccessory: Accessory = .chevron

    init(title: String,
         iconSystemName: String? = nil,
         badgeCount: Int? = nil,
         accessory: Accessory = .chevron) {
        self.rowAccessory = accessory
        super.init(frame: .zero)
        setupUI()
        configure(title: title, iconSystemName: iconSystemName)
        if let count = badgeCount { setBadge(count) }
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        backgroundColor = .clear

        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 8
        card.layer.shadowOffset = .init(width: 0, height: 4)

        iconCircle.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.1)
        iconCircle.layer.cornerRadius = 18
        iconCircle.translatesAutoresizingMaskIntoConstraints = false
        iconCircle.widthAnchor.constraint(equalToConstant: 36).isActive = true
        iconCircle.heightAnchor.constraint(equalToConstant: 36).isActive = true

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemPurple

        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .label

        badgeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.textColor = .white
        badgeLabel.layer.cornerRadius = 10
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        badgeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        switch rowAccessory {
        case .chevron:            chevronView.image = UIImage(systemName: "chevron.right")
        case .system(let name):   chevronView.image = UIImage(systemName: name)
        case .none:               chevronView.image = nil
        }
        chevronView.tintColor = .tertiaryLabel
        chevronView.setContentHuggingPriority(.required, for: .horizontal)
        chevronView.setContentCompressionResistancePriority(.required, for: .horizontal)
        chevronView.isHidden = (rowAccessory == .none)

        // STACK
        let h = UIStackView(arrangedSubviews: [iconCircle, titleLabel, UIView(), badgeLabel, chevronView])
        h.axis = .horizontal
        h.alignment = .center
        h.spacing = 12
        h.isLayoutMarginsRelativeArrangement = true
        h.layoutMargins = .init(top: 14, left: 14, bottom: 14, right: 14)

        iconCircle.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: iconCircle.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconCircle.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18)
        ])

        addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(h)
        h.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: topAnchor),
            card.leadingAnchor.constraint(equalTo: leadingAnchor),
            card.trailingAnchor.constraint(equalTo: trailingAnchor),
            card.bottomAnchor.constraint(equalTo: bottomAnchor),

            h.topAnchor.constraint(equalTo: card.topAnchor),
            h.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            h.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            h.bottomAnchor.constraint(equalTo: card.bottomAnchor),

            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
        ])

        h.isUserInteractionEnabled = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        addTarget(self, action: #selector(down), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(up),   for: [.touchCancel, .touchDragExit, .touchUpInside, .touchUpOutside])
    }

    @objc private func handleTap() {
        sendActions(for: .touchUpInside)
    }

    func configure(title: String, iconSystemName: String? = nil) {
        titleLabel.text = title
        if let name = iconSystemName { iconView.image = UIImage(systemName: name) }
        chevronView.isHidden = (rowAccessory == .none)
    }

    func setBadge(_ count: Int) {
        if count > 0 {
            badgeLabel.isHidden = false
            badgeLabel.text = "\(count)"
        } else {
            badgeLabel.isHidden = true
        }
    }

    @objc private func down() { UIView.animate(withDuration: 0.08) { self.card.alpha = 0.9 } }
    @objc private func up()   { UIView.animate(withDuration: 0.12) { self.card.alpha = 1.0 } }
}
