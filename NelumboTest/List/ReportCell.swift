//
//  ReportCell.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import UIKit

final class ReportCell: UITableViewCell {
    static let reuseID = "ReportCell"

    private let card = UIView()

    private let folioLabel = UILabel()
    private let typeChip   = ChipView(text: "—", style: .filled(bg: .systemPurple, fg: .white))

    private let titleLabel = UILabel()

    private let priorityChip = ChipView(text: "—", style: .outlined(stroke: .systemPurple, fg: .systemPurple))
    private let statusChip   = ChipView(text: "—", style: .outlined(stroke: .systemPurple, fg: .systemPurple))

    private let requestedLabel = UILabel()
    private let areaLabel = UILabel()
    private let deptLabel = UILabel()
    private let unitLabel = UILabel()
    private let creatorLabel = UILabel()
    private let providerLabel = UILabel()
    private let solverLabel = UILabel()

    private let detailButton = UIButton(type: .system)
    var onTapDetail: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.backgroundColor = .white
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.08
        card.layer.shadowRadius = 8
        card.layer.shadowOffset = CGSize(width: 0, height: 4)

        [requestedLabel, areaLabel, deptLabel, unitLabel, creatorLabel, providerLabel, solverLabel].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .secondaryLabel
            $0.numberOfLines = 1
        }
        folioLabel.font = .systemFont(ofSize: 13, weight: .regular)
        folioLabel.textColor = .secondaryLabel
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 0

        detailButton.setTitle("Ver detalle", for: .normal)
        detailButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        detailButton.backgroundColor = .systemPurple
        detailButton.setTitleColor(.white, for: .normal)
        detailButton.layer.cornerRadius = 12
        detailButton.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
        detailButton.addTarget(self, action: #selector(tapDetail), for: .touchUpInside)

        contentView.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])

        let topRow = UIStackView(arrangedSubviews: [folioLabel, UIView(), typeChip])
        topRow.axis = .horizontal
        topRow.alignment = .center

        let chipsRow = UIStackView(arrangedSubviews: [priorityChip, statusChip, UIView()])
        chipsRow.axis = .horizontal
        chipsRow.spacing = 8
        chipsRow.alignment = .leading

        let infoStack = UIStackView(arrangedSubviews: [
            requestedLabel, areaLabel, deptLabel, unitLabel, creatorLabel, providerLabel, solverLabel
        ])
        infoStack.axis = .vertical
        infoStack.spacing = 2

        let v = UIStackView(arrangedSubviews: [topRow, titleLabel, chipsRow, infoStack, detailButton])
        v.axis = .vertical
        v.spacing = 10

        v.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(v)
        NSLayoutConstraint.activate([
            v.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            v.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            v.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            v.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
    }

    @objc private func tapDetail() { onTapDetail?() }

    func configure(with vm: ReportListItem) {
        folioLabel.text = "# \(vm.folio)"
        titleLabel.text = vm.title

        priorityChip.setText(vm.priority)
        statusChip.setText(vm.statusText)
        typeChip.setText(vm.type)

        requestedLabel.attributedText  = Self.makeBold(label: "Solicitada el:", value: vm.createdAt)
        areaLabel.attributedText       = Self.makeBold(label: "Area:", value: vm.area)
        deptLabel.attributedText       = Self.makeBold(label: "Departamento:", value: vm.department)
        unitLabel.attributedText       = Self.makeBold(label: "Unidad:", value: vm.unitName)
        creatorLabel.attributedText    = Self.makeBold(label: "Creador:", value: vm.creator)
        providerLabel.attributedText   = Self.makeBold(label: "Proveedor:", value: "—")
        solverLabel.attributedText     = Self.makeBold(label: "Solucionador:", value: vm.solver)
    }

    private static func makeBold(label: String, value: String) -> NSAttributedString {
        let s = NSMutableAttributedString(
            string: "\(label) ",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.label]
        )
        s.append(NSAttributedString(
            string: value,
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.secondaryLabel]
        ))
        return s
    }

    required init?(coder: NSCoder) { fatalError() }
}
