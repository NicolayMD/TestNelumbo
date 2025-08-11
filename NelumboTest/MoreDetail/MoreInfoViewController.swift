//
//  MoreInfoViewController.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class MoreInfoViewController: UIViewController {

    private let vm: MoreInfoViewModel

    private let header = GradientHeaderView()
    private let quickActions = QuickActionsRow()

    private let scroll = UIScrollView()
    private let content = UIStackView()

    private let timeline = UIStackView()
    private let leftTitle = UILabel()
    private let leftDate = UILabel()
    private let rightTitle = UILabel()
    private let rightDate = UILabel()
    private let divider = UIView()
    private let badge = UILabel()

    private let involvedTitle = UILabel()
    private let bossRow = UILabel()
    private let assignedTitle = UILabel()
    private let assignedLabel = UILabel()

    private let zoneTitle = UILabel()
    private let unitRow = UILabel()
    private let unitLabel = UILabel()
    private let areaRow = UILabel()
    private let areaLabel = UILabel()
    private let deptRow = UILabel()
    private let deptLabel = UILabel()

    private let catTitle = UILabel()
    private let catStack = UIStackView()

    private let qTitle = UILabel()
    private let qName = UILabel()
    private let qNameLabel = UILabel()
    private let qQuestion = UILabel()
    private let qQuestionLabel = UILabel()
    private let qOptions = UILabel()

    init(viewModel: MoreInfoViewModel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let bellView = NotificationBellView(badgeCount: 5)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellView)
        buildLayout()
        applyData()
        wireActions()
    }

    private func buildLayout() {
        scroll.alwaysBounceVertical = true
        content.axis = .vertical
        content.spacing = 20

        [scroll].forEach { v in v.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(v) }
        scroll.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            content.topAnchor.constraint(equalTo: scroll.topAnchor),
            content.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            content.widthAnchor.constraint(equalTo: scroll.widthAnchor)
        ])

        content.addArrangedSubview(header)
        content.setCustomSpacing(12, after: header)
        content.addArrangedSubview(quickActions)

        timeline.axis = .horizontal
        timeline.distribution = .fillEqually
        let leftCol = makeTimelineColumn(titleLabel: leftTitle, dateLabel: leftDate)
        let rightCol = makeTimelineColumn(titleLabel: rightTitle, dateLabel: rightDate)
        timeline.addArrangedSubview(leftCol)
        timeline.addArrangedSubview(rightCol)
        content.addArrangedSubview(timeline)

        divider.backgroundColor = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        badge.backgroundColor = .systemGray
        badge.textColor = .white
        badge.font = .systemFont(ofSize: 13, weight: .semibold)
        badge.textAlignment = .center
        badge.layer.cornerRadius = 14
        badge.clipsToBounds = true
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.heightAnchor.constraint(equalToConstant: 28).isActive = true

        let dividerWrap = UIView()
        dividerWrap.translatesAutoresizingMaskIntoConstraints = false
        dividerWrap.addSubview(divider)
        dividerWrap.addSubview(badge)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: dividerWrap.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: dividerWrap.trailingAnchor, constant: -16),
            divider.centerYAnchor.constraint(equalTo: dividerWrap.centerYAnchor),
            badge.centerXAnchor.constraint(equalTo: dividerWrap.centerXAnchor),
            badge.centerYAnchor.constraint(equalTo: dividerWrap.centerYAnchor),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 90)
        ])

        content.addArrangedSubview(dividerWrap)

        involvedTitle.attributedText = sectionTitle("Involucrados")
        bossRow.attributedText = keyValue("Jefe directo:", "—")
        assignedTitle.attributedText = subsectionTitle("Usuarios asignados")
        assignedLabel.numberOfLines = 0
        assignedLabel.textColor = .label

        let invStack = UIStackView(arrangedSubviews: [involvedTitle, bossRow, assignedTitle, assignedLabel])
        invStack.axis = .vertical; invStack.spacing = 8; pinMargins(invStack)
        content.addArrangedSubview(invStack)
        content.addArrangedSubview(makeDivider())
        
        zoneTitle.attributedText = sectionTitle("Zona de gestión")
        unitRow.attributedText = keyValue("Unidad - ID", "—")
        areaRow.attributedText = keyValue("Área:", "—")
        deptRow.attributedText = keyValue("Departamento", "—")

        let zoneStack = UIStackView(arrangedSubviews: [zoneTitle, unitRow, unitLabel, areaRow, areaLabel, deptRow, deptLabel])
        zoneStack.axis = .vertical; zoneStack.spacing = 8; pinMargins(zoneStack)
        content.addArrangedSubview(zoneStack)
        content.addArrangedSubview(makeDivider())

        catTitle.attributedText = sectionTitle("Categorización")   // tilde y ortografía
        catStack.axis = .vertical; catStack.spacing = 6
        let catWrap = UIStackView(arrangedSubviews: [catTitle, catStack])
        catWrap.axis = .vertical; catWrap.spacing = 8; pinMargins(catWrap)
        content.addArrangedSubview(catWrap)
        content.addArrangedSubview(makeDivider())

        qTitle.attributedText = sectionTitle("Cuestionario")
        qName.attributedText = keyValue("Nombre", "—")
        qNameLabel.text = "Nombre de ejemplo"
        qQuestion.attributedText = keyValue("Pregunta", "—")
        qOptions.text = "Pregunta de ejemplo"

        let qWrap = UIStackView(arrangedSubviews: [qTitle, qName, qNameLabel, qQuestion, qOptions])
        qWrap.axis = .vertical; qWrap.spacing = 8; pinMargins(qWrap)
        content.addArrangedSubview(qWrap)
    }

    private func applyData() {
        header.configure(priority: vm.display.priority,
                         status: vm.display.status,
                         type: vm.display.type,
                         title: vm.display.folioAndTitle)
        header.setMoreTitle("Ver menos  »")

        leftTitle.text  = vm.display.left.title
        leftDate.text   = vm.display.left.dateText
        rightTitle.text = vm.display.right.title
        rightDate.text  = vm.display.right.dateText
        if let mid = vm.display.middleBadge { badge.text = "  \(mid)  " } else { badge.isHidden = true }

        if let boss = vm.display.bossName { bossRow.attributedText = keyValue("Jefe directo:", boss) }
        assignedLabel.text = vm.display.assignedUsers.isEmpty ? "—" : vm.display.assignedUsers.joined(separator: ", ")

        unitRow.attributedText = keyValue("Unidad - ID", "—")
        unitLabel.text = vm.display.store?.name
        areaRow.attributedText = keyValue("Area", "—")
        areaLabel.text = vm.display.area?.name
        deptRow.attributedText = keyValue("Departamento", "—")
        deptLabel.text = vm.display.department?.name ?? ""

        catStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if vm.display.categories.isEmpty {
            let l = UILabel(); l.text = "—"; l.textColor = .secondaryLabel; catStack.addArrangedSubview(l)
        } else {
            for (cat, sub) in vm.display.categories {
                let l1 = UILabel(); l1.text = cat; l1.font = .systemFont(ofSize: 16, weight: .semibold)
                catStack.addArrangedSubview(l1)
                if let s = sub, !s.isEmpty {
                    let l2 = UILabel(); l2.text = s; l2.font = .systemFont(ofSize: 16); l2.textColor = .secondaryLabel
                    catStack.addArrangedSubview(l2)
                }
            }
        }

    }
    
    private func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let wrap = UIView()
        wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -16),
            divider.centerYAnchor.constraint(equalTo: wrap.centerYAnchor)
        ])

        return wrap
    }


    private func wireActions() {
        header.onMoreTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        quickActions.mailBtn.addTarget(self, action: #selector(tapMail),    for: .touchUpInside)
        quickActions.phoneBtn.addTarget(self, action: #selector(tapPhone),  for: .touchUpInside)
        quickActions.refreshBtn.addTarget(self, action: #selector(tapRefresh), for: .touchUpInside)
    }

    @objc private func tapMail() {
        guard let email = vm.display.email, let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }

    @objc private func tapPhone() {
        guard let phone = vm.display.phone else { return }
        let digits = phone.filter { "0123456789".contains($0) }
        guard let url = URL(string: "tel://\(digits)") else { return }
        UIApplication.shared.open(url)
    }

    @objc private func tapRefresh() {
        navigationController?.popViewController(animated: true)
    }

    private func makeTimelineColumn(titleLabel: UILabel, dateLabel: UILabel) -> UIView {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.numberOfLines = 0
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .secondaryLabel
        dateLabel.numberOfLines = 0

        let st = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        st.axis = .vertical; st.spacing = 4; st.translatesAutoresizingMaskIntoConstraints = false

        let wrap = UIView(); wrap.translatesAutoresizingMaskIntoConstraints = false
        wrap.addSubview(st)
        NSLayoutConstraint.activate([
            st.topAnchor.constraint(equalTo: wrap.topAnchor),
            st.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: 16),
            st.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -16),
            st.bottomAnchor.constraint(equalTo: wrap.bottomAnchor)
        ])
        return wrap
    }

    private func sectionTitle(_ t: String) -> NSAttributedString {
        .init(string: t, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold)])
    }
    private func subsectionTitle(_ t: String) -> NSAttributedString {
        .init(string: t, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)])
    }
    private func keyValue(_ key: String, _ value: String) -> NSAttributedString {
        let s = NSMutableAttributedString(
            string: "\(key)\n",
            attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        )
        s.append(.init(
            string: value,
            attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.label]
        ))
        print(s)
        return s
    }
    private func pinMargins(_ v: UIStackView) {
        v.isLayoutMarginsRelativeArrangement = true
        v.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}
