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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.supplierLoader = SupplierLoader(endpoint: Endpoint.addressBookList())
        self.supplierLoader.load(completionHandler: handleSuppliers)
        //self.supplierLoader.loadAvatars(completionHandler: handleSuppliers)
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
            }
            return
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
            self.supplierLoader.loadAvatars(completionHandler: self.handleAvatar)
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
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
