//
//  SuppliersTableViewController.swift
//  SupplierGo
//
//  Created by Alessandro Toschi on 23/01/2021.
//

import UIKit
import Dispatch
import SupplierGoKit

class SuppliersTableViewController: UITableViewController {
    var supplierLoader: SupplierLoader!
    var selectedSupplier: Supplier?
    //var dateFormatter: DateFormatter!
    //var lastUpdate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supplierLoader = SupplierLoader(endpoint: Endpoint.addressBookList())
        self.supplierLoader.load(completionHandler: handleSuppliers)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        //self.dateFormatter = DateFormatter()
        //self.dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    @objc func pullToRefresh(_ refreshControl: UIRefreshControl){
        self.supplierLoader.load(completionHandler: handleSuppliers)
    }
    
    func handleSuppliers(error: SupplierError?){
        if let error = error{
            var errorMessage = ""
            switch error {
            case .noData, .invalidData, .invalidAvatarURL:
                errorMessage = "Unexpected error happened while downloading the suppliers!"
            case .dataError(_):
                errorMessage = "A network problem occurred while downloading the suppliers!"
            }
            errorMessage += "\nPlease try again."
            DispatchQueue.main.async {
                self.displayErrorMessage(erroreMessage: errorMessage)
                self.dismissRefreshControlIfNeeded()
            }
            return
        }
        
        DispatchQueue.main.async{
            self.dismissRefreshControlIfNeeded()
            self.tableView.reloadData()
            self.supplierLoader.loadAvatars(completionHandler: self.handleAvatar)
            //self.lastUpdate = Date()
        }
    }
    
    func handleAvatar(error: SupplierError?){
        if let error = error{
            var errorMessage = ""
            switch error {
            case .noData, .invalidData, .invalidAvatarURL:
                errorMessage = "Unexpected error happened while downloading the suppliers!"
            case .dataError(_):
                errorMessage = "A network problem occurred while downloading the suppliers!"
            }
            errorMessage += "\nPlease try again."
            DispatchQueue.main.async {
                self.displayErrorMessage(erroreMessage: errorMessage)
            }
            return
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func dismissRefreshControlIfNeeded(){
        if let refreshControl = self.tableView.refreshControl{
            if refreshControl.isRefreshing{
                refreshControl.endRefreshing()
            }
        }
    }
    
    func displayErrorMessage(erroreMessage: String){
        let alertController = UIAlertController(title: "Error!", message: erroreMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.supplierLoader.suppliers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "supplierTableViewCell", for: indexPath) as? SupplierTableViewCell else{
            fatalError("Unexpected table view cell")
        }
        let supplier = self.supplierLoader.suppliers[indexPath.row]
        if let avatarData = supplier.avatar.data, let avatarImage = UIImage(data: avatarData){
            cell.avatarImageView?.image = avatarImage
            cell.avatarImageView?.layer.cornerRadius = 15.0
        }
        cell.fullnameLabel?.text = supplier.fullname
        cell.companyLabel?.text = supplier.company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedSupplier = self.supplierLoader.suppliers[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        print(section)
        if let lastUpdate = self.lastUpdate{
            return self.dateFormatter.string(from: lastUpdate)
        }
        return nil
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "supplierDetail":
            if let supplierDetailController = segue.destination as? SupplierdDetailViewController, let selectedSupplier = self.selectedSupplier{
                supplierDetailController.supplier = selectedSupplier
            }
        default:
            return
        }
    }
    

}
