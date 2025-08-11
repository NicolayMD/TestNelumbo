//
//  ReportDetailViewController.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class ReportDetailViewController: UIViewController {
    private let viewModel: ReportDetailViewModel
    private var lastDetail: ReportDetail?

    private let scroll = UIScrollView()
    private let content = UIStackView()

    private let header = GradientHeaderView()
    private let daysBanner = DaysBannerView()

    private let descriptionTitle = UILabel()
    private let descriptionBody = UILabel()

    private var rowEvidence: ActionRowView!
    private var rowAdvanced: ActionRowView!
    private var rowReport: ActionRowView!
    private var rowComments: ActionRowView!

    private let historyTitle = UILabel()
    private let historyCard = UIView()

    var onCommentsTapped: (() -> Void)?

    init(viewModel: ReportDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        bind()
        let bellView = NotificationBellView(badgeCount: 5)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellView)
        
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = lastDetail?.id else { return }
        let serverCount = lastDetail?.reportFolioComments?.count ?? 0
        let localCount = CommentStore.shared.loadLocal(reportId: id).count
        rowComments.setBadge(serverCount + localCount)
    }

    private func setupLayout() {
        scroll.alwaysBounceVertical = true
        content.axis = .vertical
        content.spacing = 16

        [scroll].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
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
            content.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scroll.widthAnchor)
        ])

        content.addArrangedSubview(header)
        content.setCustomSpacing(0, after: header)
        content.addArrangedSubview(daysBanner)

        descriptionTitle.text = "Descripción"
        descriptionTitle.font = .systemFont(ofSize: 18, weight: .semibold)

        descriptionBody.font = .systemFont(ofSize: 16)
        descriptionBody.textColor = .label
        descriptionBody.numberOfLines = 0

        let descStack = UIStackView(arrangedSubviews: [descriptionTitle, descriptionBody])
        descStack.axis = .vertical
        descStack.spacing = 6
        content.addArrangedSubview(descStack)
        descStack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        descStack.isLayoutMarginsRelativeArrangement = true

        rowEvidence = ActionRowView(title: "Evidencias",
                                    iconSystemName: "paperclip",
                                    accessory: .chevron)
        rowAdvanced = ActionRowView(title: "Opciones avanzadas",
                                    iconSystemName: "slider.horizontal.3",
                                    accessory: .chevron)
        rowReport   = ActionRowView(title: "Informe de folio",
                                    iconSystemName: "eye",
                                    accessory: .chevron)
        rowComments = ActionRowView(title: "Comentarios",
                                    iconSystemName: "text.bubble",
                                    badgeCount: 0,
                                    accessory: .chevron)

        rowEvidence.addTarget(self, action: #selector(tapEvidence), for: .touchUpInside)
        rowAdvanced.addTarget(self, action: #selector(tapAdvanced), for: .touchUpInside)
        rowReport.addTarget(self, action: #selector(tapReport), for: .touchUpInside)
        rowComments.addTarget(self, action: #selector(tapComments), for: .touchUpInside)

        let actionsStack = UIStackView(arrangedSubviews: [rowEvidence, rowAdvanced, rowReport, rowComments])
        actionsStack.axis = .vertical
        actionsStack.spacing = 12

        let actionsInset = UIView()
        actionsInset.translatesAutoresizingMaskIntoConstraints = false
        actionsInset.addSubview(actionsStack)
        actionsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionsStack.topAnchor.constraint(equalTo: actionsInset.topAnchor),
            actionsStack.leadingAnchor.constraint(equalTo: actionsInset.leadingAnchor, constant: 16),
            actionsStack.trailingAnchor.constraint(equalTo: actionsInset.trailingAnchor, constant: -16),
            actionsStack.bottomAnchor.constraint(equalTo: actionsInset.bottomAnchor)
        ])
        content.addArrangedSubview(actionsInset)
        content.setCustomSpacing(20, after: actionsInset)

        historyTitle.text = "Historial"
        historyTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        let sep = UIView()
        sep.backgroundColor = .separator
        sep.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let historyHeader = UIStackView(arrangedSubviews: [historyTitle])
        historyHeader.axis = .vertical
        historyHeader.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        historyHeader.isLayoutMarginsRelativeArrangement = true
        content.addArrangedSubview(sep)
        content.addArrangedSubview(historyHeader)

        historyCard.backgroundColor = .white
        historyCard.layer.cornerRadius = 14
        historyCard.layer.shadowColor = UIColor.black.cgColor
        historyCard.layer.shadowOpacity = 0.06
        historyCard.layer.shadowRadius = 8
        historyCard.layer.shadowOffset = .init(width: 0, height: 4)
        historyCard.translatesAutoresizingMaskIntoConstraints = false
        historyCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 140).isActive = true

        let hcLabel = UILabel()
        hcLabel.text = "Pedir cotización\nProveedor: —"
        hcLabel.numberOfLines = 0
        hcLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        let primary = UIButton(type: .system)
        primary.setTitle("Pedir cotización", for: .normal)
        primary.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        primary.backgroundColor = .systemBlue
        primary.setTitleColor(.white, for: .normal)
        primary.layer.cornerRadius = 10
        primary.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)

        let secondary = UIButton(type: .system)
        secondary.setTitle("Reasignar proveedor", for: .normal)
        secondary.layer.borderWidth = 1
        secondary.layer.borderColor = UIColor.systemBlue.cgColor
        secondary.layer.cornerRadius = 10
        secondary.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)

        let hcStack = UIStackView(arrangedSubviews: [hcLabel, secondary, primary])
        hcStack.axis = .vertical
        hcStack.spacing = 12
        hcStack.translatesAutoresizingMaskIntoConstraints = false
        historyCard.addSubview(hcStack)
        NSLayoutConstraint.activate([
            hcStack.topAnchor.constraint(equalTo: historyCard.topAnchor, constant: 16),
            hcStack.leadingAnchor.constraint(equalTo: historyCard.leadingAnchor, constant: 16),
            hcStack.trailingAnchor.constraint(equalTo: historyCard.trailingAnchor, constant: -16),
            hcStack.bottomAnchor.constraint(equalTo: historyCard.bottomAnchor, constant: -16),
        ])

        let historyInset = UIView()
        historyInset.translatesAutoresizingMaskIntoConstraints = false
        historyInset.addSubview(historyCard)
        NSLayoutConstraint.activate([
            historyCard.topAnchor.constraint(equalTo: historyInset.topAnchor),
            historyCard.leadingAnchor.constraint(equalTo: historyInset.leadingAnchor, constant: 16),
            historyCard.trailingAnchor.constraint(equalTo: historyInset.trailingAnchor, constant: -16),
            historyCard.bottomAnchor.constraint(equalTo: historyInset.bottomAnchor)
        ])
        content.addArrangedSubview(historyInset)

        content.setCustomSpacing(8, after: daysBanner)
    }

    private func bind() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                guard let self else { return }
                switch state {
                case .loading:
                    break

                case .loaded(let detail):
                    self.lastDetail = detail

                    let vm = ReportDetailDisplay(detail: detail)
                    self.header.configure(priority: vm.priority,
                                          status: vm.status,
                                          type: vm.type,
                                          title: "\(vm.folio) - \(vm.title)")
                    self.header.onMoreTapped = { [weak self] in
                        guard let self else { return }
                        let moreVM = MoreInfoViewModel(detail: detail)
                        let moreVC = MoreInfoViewController(viewModel: moreVM)
                        self.navigationController?.pushViewController(moreVC, animated: true)
                    }

                    self.daysBanner.setText(vm.daysElapsedText)
                    self.descriptionBody.text = vm.description

                    let serverCount = detail.reportFolioComments?.count ?? 0
                    let localCount = CommentStore.shared.loadLocal(reportId: detail.id).count
                    self.rowComments.setBadge(serverCount + localCount)

                    let attending = [detail.attendingByUser?.firstName, detail.attendingByUser?.lastName].compactMap { $0 }.joined(separator: " ")
                    let dptoMgr = [detail.department?.userManage?.firstName, detail.department?.userManage?.lastName].compactMap { $0 }.joined(separator: " ")
                    let assign = [detail.reportFolioUserAssign?.first?.firstName, detail.reportFolioUserAssign?.first?.lastName].compactMap { $0 }.joined(separator: " ")
                    let provider = attending.isEmpty ? (dptoMgr.isEmpty ? (assign.isEmpty ? "—" : assign) : dptoMgr) : attending

                    if let stack = self.historyCard.subviews.compactMap({ $0 as? UIStackView }).first,
                       let label = stack.arrangedSubviews.first as? UILabel {
                        label.text = "Pedir cotización\nProveedor: \(provider)"
                    }

                case .error(let msg):
                    let ac = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                    ac.addAction(.init(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }

    @objc private func tapComments() {
        guard let detail = lastDetail else { return }
        let display = ReportDetailDisplay(detail: detail)
        let vm = CommentsViewModel(reportId: detail.id, serverComments: detail.reportFolioComments)
        let vc = CommentsViewController(reportDetailHeader: display, viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func tapEvidence() {
        // TODO: navegar a evidencias
    }

    @objc private func tapAdvanced() {
        // TODO: navegar a opciones avanzadas
    }

    @objc private func tapReport() {
        // TODO: navegar a informe de folio
    }
}
