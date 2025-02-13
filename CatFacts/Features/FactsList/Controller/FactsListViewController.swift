//
//  FactsListViewController.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import UIKit
import Combine

class FactsListViewController: UIViewController {
    
    // MARK: - Declarations
    var viewModel: FactsListViewModelProtocol?
    var filteredFacts = [CatFact]()
    weak var coordinator: FactsListCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FactsListCell.self, forCellReuseIdentifier: FactsListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .blue
        tableView.separatorInset = .init(top: 0, left: 8, bottom: 0, right: 8)
        return tableView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search your cat facts"
        searchBar.keyboardType = .asciiCapable
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    @Published var facts = [CatFact]() {
        didSet {
            filteredFacts = facts
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Init and lifecycle funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel?.getFacts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
}

// MARK: - Private ext
private extension FactsListViewController {
    func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        setupConstraints()
        addDoneButtonToKeyboard()
    }
    
    func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))

        toolbar.items = [flexSpace, doneButton]
        searchBar.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel?.factsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.facts, on: self)
            .store(in: &cancellables)
        
        viewModel?.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                guard error != nil else { return }
                self?.showError(with: error)
            })
            .store(in: &cancellables)
    }
    
    func showError(with error: Error?) {
        let alert = UIAlertController(title: "Error", message:  error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.viewModel?.getFacts()
        }))
        present(alert, animated: true)
    }
}

// MARK: - TableView Protocols
extension FactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredFacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FactsListCell.identifier, for: indexPath) as? FactsListCell else { return UITableViewCell() }
        let fact = filteredFacts[indexPath.row]
        let isVerified = fact.status.verified
        let isLastNinetyDays = fact.isLastNinetyDays
        cell.setDescription(with: fact.text)
        cell.setIcons(showVerifiedImage: isVerified, showRecentImage: isLastNinetyDays)
        return cell
    }
}

// MARK: - SearchBar Delegate
extension FactsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredFacts = searchText.isEmpty ? facts : facts.filter {
            $0.text.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
