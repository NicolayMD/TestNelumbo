//
//  ChipView.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import UIKit

final class ChipView: UIView {
    enum Style {
        case filled(bg: UIColor, fg: UIColor)
        case outlined(stroke: UIColor, fg: UIColor, bg: UIColor = .clear)
    }

    private let label = UILabel()
    private var style: Style = .outlined(stroke: .systemPurple, fg: .systemPurple)

    init(text: String, style: Style = .outlined(stroke: .systemPurple, fg: .systemPurple)) {
        super.init(frame: .zero)
        self.style = style
        layer.cornerRadius = 12
        layer.masksToBounds = true

        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.text = text

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        apply(style)
    }

    func setText(_ text: String) { label.text = text }
    func setStyle(_ style: Style) { self.style = style; apply(style) }

    private func apply(_ style: Style) {
        switch style {
        case .filled(let bg, let fg):
            backgroundColor = bg
            layer.borderWidth = 0
            label.textColor = fg
        case .outlined(let stroke, let fg, let bg):
            backgroundColor = bg
            layer.borderWidth = 1
            layer.borderColor = stroke.cgColor
            label.textColor = fg
        }
    }

    required init?(coder: NSCoder) { fatalError() }
}
