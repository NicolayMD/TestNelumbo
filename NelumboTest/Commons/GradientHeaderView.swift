//
//  GradientHeaderView.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class GradientHeaderView: UIView {
    private let gradient = CAGradientLayer()
    private let priorityChip = ChipView(text: "—")
    private let statusChip = ChipView(text: "—")
    private let typeChip = ChipView(text: "—")
    private let titleLabel = UILabel()
    private let moreBtn = UIButton(type: .system)
    var onMoreTapped: (() -> Void)?   // <— NUEVO

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradient, at: 0)
        gradient.startPoint = CGPoint(x: 0, y: 0); gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemIndigo.cgColor]

        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white; titleLabel.numberOfLines = 0

        moreBtn.setTitle("Ver más   »", for: .normal)
        moreBtn.setTitleColor(.white, for: .normal)
        moreBtn.setContentHuggingPriority(.required, for: .horizontal)
        moreBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
        moreBtn.addTarget(self, action: #selector(tapMore), for: .touchUpInside)
        

        let chipsTop = UIStackView(arrangedSubviews: [priorityChip, statusChip, UIView()])
        chipsTop.axis = .horizontal; chipsTop.spacing = 8; chipsTop.alignment = .leading

        let bottomRow = UIStackView(arrangedSubviews: [typeChip, UIView(), moreBtn])
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center       // <- asegura alineación vertical
        bottomRow.spacing = 8

        let v = UIStackView(arrangedSubviews: [chipsTop, titleLabel, bottomRow])
        v.axis = .vertical; v.spacing = 12
        v.translatesAutoresizingMaskIntoConstraints = false
        addSubview(v)

        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() { super.layoutSubviews(); gradient.frame = bounds }
    
    @objc private func tapMore() { onMoreTapped?()}

    func configure(priority: String, status: String, type: String, title: String) {
        priorityChip.setText(priority.capitalized)
        priorityChip.setStyle(.filled(bg: UIColor.systemRed, fg: .white))

        statusChip.setText(status)
        statusChip.setStyle(.outlined(stroke: .systemPurple, fg: .systemPurple, bg: .white))

        typeChip.setText(type)
        typeChip.setStyle(.filled(bg: .systemPurple, fg: .white))

        titleLabel.text = "# \(title)"
    }

    func setMoreTitle(_ title: String) {
        moreBtn.setTitle(title, for: .normal)
    }

   
}
