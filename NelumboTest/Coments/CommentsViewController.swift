//
//  CommentsViewController.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    private let viewModel: CommentsViewModel
    private let header = GradientHeaderView()

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputBar = UIView()
    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let loader = UIActivityIndicatorView(style: .medium)

    private var items: [LocalComment] = []

    init(reportDetailHeader: ReportDetailDisplay, viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Comentarios"
        header.configure(priority: reportDetailHeader.priority,
                         status: reportDetailHeader.status,
                         type: reportDetailHeader.type,
                         title: reportDetailHeader.folio + " - " + reportDetailHeader.title)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let bellView = NotificationBellView(badgeCount: 5)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellView)
        buildUI()
        bind()
        viewModel.load()
        observeKeyboard()
    }

    private func buildUI() {
        header.setMoreTitle("Ver más  »")
        header.onMoreTapped = { [weak self] in self?.navigationController?.popViewController(animated: true) }

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset.bottom = 76

        inputBar.backgroundColor = .clear
        let inputCard = UIView()
        inputCard.backgroundColor = .white
        inputCard.layer.cornerRadius = 14
        inputCard.layer.shadowColor = UIColor.black.cgColor
        inputCard.layer.shadowOpacity = 0.08
        inputCard.layer.shadowRadius = 8
        inputCard.layer.shadowOffset = .init(width: 0, height: 4)

        textField.placeholder = "Comentario..."
        textField.delegate = self
        textField.returnKeyType = .send

        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 12
        sendButton.contentEdgeInsets = .init(top: 10, left: 12, bottom: 10, right: 12)
        sendButton.addTarget(self, action: #selector(tapSend), for: .touchUpInside)

        loader.hidesWhenStopped = true

        [header, tableView, inputBar].forEach { v in v.translatesAutoresizingMaskIntoConstraints = false; view.addSubview(v) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),

            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputBar.heightAnchor.constraint(equalToConstant: 64)
        ])

        inputBar.addSubview(inputCard)
        inputCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputCard.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: 16),
            inputCard.trailingAnchor.constraint(equalTo: inputBar.trailingAnchor, constant: -16),
            inputCard.topAnchor.constraint(equalTo: inputBar.topAnchor),
            inputCard.bottomAnchor.constraint(equalTo: inputBar.bottomAnchor, constant: -8)
        ])

        let h = UIStackView(arrangedSubviews: [textField, sendButton])
        h.axis = .horizontal
        h.spacing = 12
        inputCard.addSubview(h)
        h.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            h.leadingAnchor.constraint(equalTo: inputCard.leadingAnchor, constant: 16),
            h.trailingAnchor.constraint(equalTo: inputCard.trailingAnchor, constant: -12),
            h.topAnchor.constraint(equalTo: inputCard.topAnchor, constant: 10),
            h.bottomAnchor.constraint(equalTo: inputCard.bottomAnchor, constant: -10)
        ])
    }

    private func bind() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                guard let self else { return }
                switch state {
                case .idle: break
                case .loading:
                    self.loader.startAnimating()
                case .loaded(let list):
                    self.loader.stopAnimating()
                    self.items = list
                    self.tableView.reloadData()
                    self.scrollToBottomIfNeeded()
                case .sending(let isSending):
                    self.sendButton.isEnabled = !isSending
                    self.sendButton.alpha = isSending ? 0.6 : 1.0
                case .error(let msg):
                    self.loader.stopAnimating()
                    let ac = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                    ac.addAction(.init(title: "OK", style: .default))
                    self.present(ac, animated: true)
                }
            }
        }
    }

    @objc private func tapSend() {
        let msg = textField.text ?? ""
        viewModel.send(message: msg)
        textField.text = nil
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool { tapSend(); return true }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseID, for: indexPath) as! CommentCell
        let item = items[indexPath.row]
        c.configure(author: item.authorNameDisplay, message: item.messageDisplay, dateText: item.dateTextDisplay)
        return c
    }

    private func scrollToBottomIfNeeded() {
        guard !items.isEmpty else { return }
        let idx = IndexPath(row: items.count - 1, section: 0)
        tableView.scrollToRow(at: idx, at: .bottom, animated: true)
    }

    // Keyboard
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(kb), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc private func kb(_ n: Notification) {
        guard let info = n.userInfo,
              let end = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let dur = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }

        let insets = view.convert(end, from: nil).intersects(view.bounds)
            ? end.height - view.safeAreaInsets.bottom
            : 0

        UIView.animate(withDuration: dur, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16), animations: {
            self.tableView.contentInset.bottom = insets + 76
            self.tableView.scrollIndicatorInsets.bottom = insets + 76
            self.inputBar.transform = CGAffineTransform(translationX: 0, y: -insets)
        }, completion: { _ in
            self.scrollToBottomIfNeeded()
        })
    }
}
