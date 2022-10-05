//
//  ListViewController.swift
//  BDSwiss
//
//  Created by mohammadreza on 9/29/22.
//

import UIKit
import Core

protocol ListService {
    /// Provide datas for ListViewController
    ///
    /// This method provide array of ItemViewModel  for displaying on ListViewController
    ///
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}

class ListViewController: UITableViewController {
    var service: ListService?
    var loading: UIActivityIndicatorView!
    
    var items = [ItemViewModel]()
    
    init(service: ListService) {
        super.init(nibName: nil, bundle: nil)
        self.service = service
        
        loading = UIActivityIndicatorView(style: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.registerCells([UITableViewCell.self])
        tableView.accessibilityIdentifier = "ListTableView"
        
        setupLoadingIndicator()
        
        refresh()
        
    }
    
    @objc private func refresh() {
        service?.loadItems(completion: { result in
            switch result {
            case let .success(result):
                self.loading.stopAnimating()
                self.items = result
                self.tableView.reloadData()
                
            case let .failure(error):
                self.loading.stopAnimating()
                self.show(error: error, secondAction: UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.refresh()
                }))
            }
        })
    }
    
    private func setupLoadingIndicator() {
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint(item: loading!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        loading.startAnimating()
        loading.hidesWhenStopped = true
    }

}
extension ListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.configure(items[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

