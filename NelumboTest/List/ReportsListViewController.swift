//
//  ReportsListViewController.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import UIKit

final class ReportsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let fabSize: CGFloat = 56
    private var fabOffset: CGFloat = -2
    private let firstCardPadding: CGFloat = -15


    private let viewModel: ReportsListViewModel
    private var items: [ReportListItem] = []


    private let filtersContainer = UIView()
    private let headerBar = UIButton(type: .system)
    private let filterBtn = UIButton(type: .system)
    private let orderBtn  = UIButton(type: .system)
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loader    = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let fab       = UIButton(type: .system)

    private let auth = AuthService.shared


    init(viewModel: ReportsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Check+"
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.darkGray // Fondo de la barra
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Color del título
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Si usas título grande
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        let bellView = NotificationBellView(badgeCount: 5)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bellView)
        
        setupHeader()
        setupTable()
        setupStateViews()
        setupFAB()
        bind()
        signInThenLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyTopClearance()
    }
    

    private func setupHeader() {
        filtersContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersContainer)

        headerBar.setTitle("  🏬  Todas las tiendas   ▶︎", for: .normal)
        headerBar.setTitleColor(.white, for: .normal)
        headerBar.backgroundColor = .systemPurple
        headerBar.contentHorizontalAlignment = .left
        headerBar.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)

        let sep = UIView(); sep.backgroundColor = .separator
        filterBtn.setTitle("Filtrar por ▾", for: .normal)
        orderBtn.setTitle("Ordenar por ▾", for: .normal)

        let filtersRow = UIStackView(arrangedSubviews: [filterBtn, UIView(), orderBtn])
        filtersRow.axis = .horizontal
        filtersRow.alignment = .center
        filtersRow.isLayoutMarginsRelativeArrangement = true
        filtersRow.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)

        [headerBar, filtersRow, sep].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            filtersContainer.addSubview($0)
        }

        NSLayoutConstraint.activate([
            filtersContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filtersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            headerBar.topAnchor.constraint(equalTo: filtersContainer.topAnchor),
            headerBar.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            headerBar.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            headerBar.heightAnchor.constraint(equalToConstant: 48),

            filtersRow.topAnchor.constraint(equalTo: headerBar.bottomAnchor),
            filtersRow.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            filtersRow.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),

            sep.topAnchor.constraint(equalTo: filtersRow.bottomAnchor),
            sep.leadingAnchor.constraint(equalTo: filtersContainer.leadingAnchor),
            sep.trailingAnchor.constraint(equalTo: filtersContainer.trailingAnchor),
            sep.heightAnchor.constraint(equalToConstant: 1),

            filtersContainer.bottomAnchor.constraint(equalTo: sep.bottomAnchor)
        ])
    }

    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle  = .none
        tableView.register(ReportCell.self, forCellReuseIdentifier: ReportCell.reuseID)
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight  = UITableView.automaticDimension

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filtersContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        applyTopClearance()
    }

    private func applyTopClearance() {
        let clearance = fabOffset + (fabSize / 2) + firstCardPadding
        tableView.contentInset.top = clearance
        tableView.scrollIndicatorInsets.top = clearance
    }

    private func setupStateViews() {
        loader.hidesWhenStopped = true
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.text = "Sin resultados"
        emptyLabel.isHidden = true

        [loader, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
    }

    private func setupFAB() {
        fab.setTitle("+", for: .normal)
        fab.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        fab.backgroundColor = .systemPurple
        fab.tintColor = .white
        fab.layer.cornerRadius = fabSize / 2
        fab.addTarget(self, action: #selector(tapCreate), for: .touchUpInside)

        fab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fab)

        NSLayoutConstraint.activate([
            fab.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fab.centerYAnchor.constraint(equalTo: filtersContainer.bottomAnchor, constant: fabOffset),
            fab.widthAnchor.constraint(equalToConstant: fabSize),
            fab.heightAnchor.constraint(equalToConstant: fabSize)
        ])

        view.bringSubviewToFront(fab)
    }

    private func bind() {
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                guard let self else { return }
                switch state {
                case .idle: break
                case .loading:
                    self.loader.startAnimating()
                    self.emptyLabel.isHidden = true
                case .loaded(let items):
                    self.loader.stopAnimating()
                    self.items = items
                    self.emptyLabel.isHidden = !items.isEmpty
                    self.tableView.reloadData()
                case .error(let msg):
                    self.loader.stopAnimating()
                    self.emptyLabel.isHidden = false
                    self.emptyLabel.text = msg
                }
            }
        }

        viewModel.onSelect = { [weak self] id in
            self?.pushDetail(id: id)
        }
    }

    private func signInThenLoad() {
        if TokenStorage.shared.token != nil {
            viewModel.load()
            return
        }
        loader.startAnimating()
        auth.signIn { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.viewModel.load()
                case .failure(let e):
                    self?.loader.stopAnimating()
                    self?.showError("No se pudo iniciar sesión.\n\(e.description)") {
                        self?.signInThenLoad()
                    }
                }
            }
        }
    }

    private func pushDetail(id: Int) {
        let vm = ReportDetailViewModel(id: id)
        let vc = ReportDetailViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.reuseID, for: indexPath) as! ReportCell
        cell.configure(with: vm)
        cell.onTapDetail = { [weak self] in self?.viewModel.select(item: vm) }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.select(item: items[indexPath.row])
    }

    @objc private func tapCreate() {
    }

    private func showError(_ msg: String, retry: (() -> Void)? = nil) {
        let ac = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        if let retry = retry { ac.addAction(.init(title: "Reintentar", style: .default) { _ in retry() }) }
        ac.addAction(.init(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
}
