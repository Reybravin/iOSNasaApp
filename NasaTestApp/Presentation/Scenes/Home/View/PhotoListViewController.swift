//
//  PhotoListViewController.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.07.2021.
//

import UIKit


class PhotoListViewController: UIViewController, Alertable, Asyncable {
    
    private var tableHeaderView : PhotoListTableHeaderView!
    private var viewModel : PhotoListViewModelInterface!
    private var viewControllersFactory : HomeViewControllersFactory!
 
    static func create(with viewModel: PhotoListViewModelInterface, viewControllersFactory: HomeViewControllersFactory) -> PhotoListViewController {
        let vc = PhotoListViewController()
        vc.viewModel = viewModel
        vc.viewControllersFactory = viewControllersFactory
        return vc
    }
    
    //MARK: UI
    
    private var activityIndicator : UIActivityIndicatorView?
    
    private lazy var tableView : UITableView = {
        let view = UITableView()
        view.register(cellClass: UITableViewCell.self)
        view.registerNib(cellClass: PhotoCell.self)
        view.rowHeight = 100
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
        bind(to: viewModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    //MARK: UI Setup
    
    private func setupView(){
        title = "NASA Photos"
        addTableView()
    }
    
    private func addTableView(){
        view.addSubview(tableView)
        tableView.pinToSafeArea(view: view)
        addTableHeaderView()
    }
    
    private func addTableHeaderView() {
        let viewBounds = UIScreen.main.bounds
        let headerView = PhotoListTableHeaderView(frame: CGRect(x: 0, y: 0, width: viewBounds.width, height: viewBounds.height / 4))
        self.tableHeaderView = headerView
        tableView.tableHeaderView = headerView
    }
    
    
    //MARK: Data Binding
    
    private func bind(to viewModel: PhotoListViewModelOutput){
        
        viewModel.isLoading.observe(on: self) { [weak self] in self?.handleIsLoading($0) }
        viewModel.errorText.observe(on: self) { [weak self] in self?.showError($0) }
        viewModel.headerImageUrl.observe(on: self) { [weak self] in self?.handleHeaderImageUrlUpdated($0) }
        viewModel.cellViewModels.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
        
    }

    private func removeObservers() {
        viewModel.headerImageUrl.remove(observer: self)
        viewModel.errorText.remove(observer: self)
        viewModel.isLoading.remove(observer: self)
        viewModel.cellViewModels.remove(observer: self)
    }
    
    private func handleHeaderImageUrlUpdated(_ url : URL?) {
        guard let url = url else { return }
        tableHeaderView.setImage(withUrl: url)
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: "Error", message: error)
    }
    
    private func handleIsLoading(_ isLoading: Bool) {
        if isLoading {
            guard activityIndicator == nil else { return }
            activityIndicator = showActivityIndicator(onView: self.view)
        } else {
            hideActivityIndicator(&activityIndicator)
        }
    }
    
}


//MARK: UITableView Delegate

extension PhotoListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: UITableView DataSource

extension PhotoListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PhotoCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let cellViewModels = viewModel.cellViewModels.value
        if cellViewModels.indices.contains(indexPath.row) {
            let cellViewModel = cellViewModels[indexPath.row]
            cell.configureView(with: cellViewModel)
        }
        return cell
    }
}
