//
//  PhotoListViewController.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.07.2021.
//

import UIKit


class PhotoListViewController: UIViewController {
    
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
    
    private lazy var tableView : UITableView = {
        let view = UITableView()
        view.register(cellClass: UITableViewCell.self)
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
        viewModel.headerImageUrl.observe(on: self) { [weak self] url in
            guard let url = url else { return } 
            self?.tableHeaderView.setImage(withUrl: url)
        }
    }

    private func removeObservers() {
        viewModel.headerImageUrl.remove(observer: self)
    }
    
}


//MARK: API Requests

extension PhotoListViewController {
}


//MARK: UITableView Delegate

extension PhotoListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}


//MARK: UITableView DataSource

extension PhotoListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        cell.backgroundColor = .yellow
        return cell
    }
}
