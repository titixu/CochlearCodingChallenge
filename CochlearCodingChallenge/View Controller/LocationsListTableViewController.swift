//
//  LocationsListTableViewController.swift
//  CochlearCodingChallenge
//
//  Created by An Xu on 2/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit

class LocationsListTableViewController: UITableViewController {

    private let cellIdentifier = "LocationListCell"
    
    var viewModel: LocationsListViewModel
    
    init(viewModel: LocationsListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationDetails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = viewModel.title(indexPath)
        cell.detailTextLabel?.text = viewModel.subTitle(indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = viewModel.location(indexPath)
        let locationDetailViewModel = LocationDetailViewModel(storage: viewModel.storage, location: location)
        let viewController = LocationDetailViewController(viewModel: locationDetailViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }

}
