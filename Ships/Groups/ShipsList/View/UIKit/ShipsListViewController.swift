//
//  ShipsListViewController.swift
//  Ships
//
//  Created by Konstantine Tsirgvava on 28/03/2026.
//

import UIKit
import SwiftUI
import ShipsModels
import ShipsUI
import Combine

final class ShipsListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ShipsListTableViewCell.self, forCellReuseIdentifier: ShipsListTableViewCell.reuseIdentifier)
        tableView.rowHeight = Constants.rowHeight
        tableView.separatorStyle = .none
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchBar: ShipsSearchBar = {
        let searchBar = ShipsSearchBar()
        searchBar.setupView(placeholder: "Search Ships")
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var loadingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading ships..."
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: Constants.loadingLabelFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No ships found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: Constants.emptyStateLabelFontSize)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    private let viewModel: ShipsListViewModel
    private var dataSource: UITableViewDiffableDataSource<Int, ShipDisplayItem>!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(viewModel: ShipsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupBindings()
        loadData()
    }
    
    // MARK: - Methods
    private func setupBindings() {
        viewModel.$filteredShips
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ships in
                guard let self else { return }
                updateSnapshot(with: ships)
                emptyStateLabel.isHidden = ships.isEmpty == false || viewModel.isLoading
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading && !(refreshControl.isRefreshing) {
                    loadingContainerView.isHidden = false
                    loadingIndicator.startAnimating()
                    emptyStateLabel.isHidden = true
                } else {
                    loadingContainerView.isHidden = true
                    loadingIndicator.stopAnimating()
                    refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showError(message: message) {
                    self?.viewModel.clearError()
                }
            }
            .store(in: &cancellables)
        
        searchBar.onSearch = { [weak self] query in
            self?.viewModel.searchText = query ?? .empty
        }
    }
    
    private func loadData() {
        Task {
            await viewModel.fetchShips(offset: .zero)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingContainerView)
        view.addSubview(emptyStateLabel)
        
        loadingContainerView.addSubview(loadingIndicator)
        loadingContainerView.addSubview(loadingLabel)
        
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.searchBarHorizontalPadding),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.searchBarHorizontalPadding),
            searchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Constants.tableViewTopPadding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingIndicator.topAnchor.constraint(equalTo: loadingContainerView.topAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: loadingContainerView.centerXAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: Constants.loadingLabelTopPadding),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingContainerView.centerXAnchor),
            loadingLabel.bottomAnchor.constraint(equalTo: loadingContainerView.bottomAnchor),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.fetchShips(offset: .zero)
        }
    }
}

// MARK: - Data Source
extension ShipsListViewController {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, ShipDisplayItem>(tableView: tableView) { [weak self] tableView, indexPath, item in
            guard let self,
            let cell = tableView.dequeueReusableCell(withIdentifier: ShipsListTableViewCell.reuseIdentifier, for: indexPath) as? ShipsListTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: item)
            cell.onFavoriteToggle = { [weak self] in
                self?.viewModel.toggleFavorite(for: item.ship.id)
            }
            
            return cell
        }
    }
    
    private func updateSnapshot(with items: [ShipDisplayItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ShipDisplayItem>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - UITableViewDelegate
extension ShipsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.selectShip(item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - Constants.paginationThreshold {
            Task {
                await viewModel.loadNextPage()
            }
        }
    }
}

// MARK: - Constants
private extension ShipsListViewController {
    enum Constants {
        static let rowHeight: CGFloat = 150
        static let emptyStateLabelFontSize: CGFloat = 17
        static let loadingLabelFontSize: CGFloat = 17
        static let loadingLabelTopPadding: CGFloat = 8
        static let searchBarHeight: CGFloat = 50
        static let searchBarHorizontalPadding: CGFloat = 10
        static let tableViewTopPadding: CGFloat = 10
        static let paginationThreshold: CGFloat = 100
    }
}

// NOTE: - Uncomment for Preview

//fileprivate struct ShipsListViewControllerRepresentable: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        return ShipsListViewController(viewModel: .init(
//            networkService: MockShipsNetworkService(),
//            favoritesStorage: FavoritesStorage())
//        )
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//}
//
//#Preview {
//    ShipsListViewControllerRepresentable()
//        .ignoresSafeArea()
//}
