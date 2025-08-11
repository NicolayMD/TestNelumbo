//
//  QuickActionsRow.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class QuickActionsRow: UIView {
    let mailBtn   = CircleIconButton(systemName: "envelope.fill")
    let phoneBtn  = CircleIconButton(systemName: "phone.fill")
    let refreshBtn = CircleIconButton(systemName: "arrow.clockwise")

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [mailBtn, phoneBtn, refreshBtn])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
