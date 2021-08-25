//
//  PhotoListViewController.swift
//  NasaTestApp
//
//  Created by Serhii Sachuk on 25.07.2021.
//

import UIKit

struct PhotoItem {
    let image       : UIImage?
    let title       : String
    let subtitle    : String
}

final class PhotoCellViewModel {
    
    let model : PhotoItem
    
    init(model: PhotoItem) {
        self.model = model
    }
    
}


protocol PhotoListViewModelInput {
    func viewDidLoad()
}

protocol PhotoListViewModelOutput {
    var cellViewModels : [PhotoCellViewModel] { get }
}

protocol PhotoListViewModelInterface : PhotoListViewModelInput, PhotoListViewModelOutput {}

final class PhotoListViewModel {
    
}

class PhotoListViewController: UIViewController {
    
    private let nasaDataRepository = NasaDataRepository()

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
        fetchApod()
        fetchEpicImages()
    }
    
    //MARK: UI Setup
    
    private func setupView(){
        addTableView()
    }
    
    private func addTableView(){
        view.addSubview(tableView)
        tableView.pinToSafeArea(view: view)
    }
    
    //MARK: Data Binding
    
    private func bind(to viewModel: PhotoListViewModelOutput){
        //
    }
    
    private func fetchApod() {
        nasaDataRepository.fetchApod() { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchEpicImages() {
        nasaDataRepository.fetchEpicImages { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }

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
