//
//  ViewController.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let tableView = UITableView()
	var images: [ImageViewModel] = []
	let reuseId = "UITableViewCellreuseId"
	let interactor: InteractorInput
    var searchController: UISearchController!
    var searchActive : Bool = false
    var localModels: [ImageModel] = []
    var searchString: String  = ""

	init(interactor: InteractorInput) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}
	required init?(coder: NSCoder) {
		fatalError("Метод не реализован")
	}
	override func viewDidLoad() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        
		super.viewDidLoad()
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
		tableView.register(TableViewCell.self, forCellReuseIdentifier: reuseId)
		tableView.dataSource = self

	}

    @objc private func search() {
        interactor.loadImageList(by: searchString) { [weak self] models in
            self?.localModels.append(contentsOf: models)
            let model = ImageViewModel(description: "", image: nil)
            let singleArray = [ImageViewModel](repeating: model, count: models.count)
            self?.images.append(contentsOf: singleArray)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }

        }
    }

	private func loadImages(with models: [ImageModel]) {
		let group = DispatchGroup()
		for model in localModels {
            group.enter()
			interactor.loadImage(at: model.path) { [weak self] image in
				guard let image = image else {
					group.leave()
					return
				}
				let viewModel = ImageViewModel(description: model.description,
											   image: image)
				self?.images.append(viewModel)
				group.leave()
			}

		}

		group.notify(queue: DispatchQueue.main) {
			self.tableView.reloadData()
		}
	}
    private func loadOneImage(row: Int) {
        let imagePath = localModels[row].path
        interactor.loadImage(at: imagePath) { [weak self] image in
            if let image = image {
                let model = ImageViewModel(description: self!.localModels[row].description, image: image)
                self?.images[row] = model
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
        
	}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! TableViewCell
        let model = images[indexPath.row]
        if model.image != nil {
            cell.imageView?.image = model.image
            cell.textLabel?.text = model.description
        } else {
            self.loadOneImage(row: indexPath.row)
            cell.textLabel?.text = model.description
        }
      
            return cell
	}
    
}

    extension ViewController: UISearchBarDelegate
    {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchString = searchText
            
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            
            self.perform(#selector(search), with: nil, afterDelay: 2)

        }
    }

