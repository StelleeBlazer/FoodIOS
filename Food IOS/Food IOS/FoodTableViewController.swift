//
//  FoodTableViewController.swift
//  Food IOS
//
//  Created by Mac n Cheese on 24/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class FoodTableViewController: UITableViewController {
    
    var foodData = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllFood()
    }
    
    func getAllFood(){
        
        Alamofire.request(Constant().BASE_URL_API + "getMakanan") .responseJSON { (response) in
            
            let allJson = JSON(response.result.value as Any)
            let sukses = allJson["sukses"].boolValue
            
            if sukses{
                self.foodData = allJson["data"].arrayObject as! [[String : Any]]
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFood", for: indexPath) as!
        FoodTableViewCell
        
        let index = foodData[indexPath.row]
        let name = index["menu_nama"]
        let price = index["menu_harga"]
        let image = index["menu_gambar"] as? String
        
        cell.cellName.text = name as? String
        cell.cellPrice.text = price as? String
        
        Alamofire.request(image!).response { (dataimage) in
            cell.cellImage.image = UIImage(data: dataimage.data!)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let update = UIContextualAction(style: .normal, title: "Update") { (action, view, handler) in
            self.performSegue(withIdentifier: "updateFood", sender: indexPath)
        }
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            self.showAlertDelete(indexpath: indexPath)
        }
        
        update.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.6035881639, green: 0, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [update, delete])
    }
    
    func showAlertDelete(indexpath : IndexPath){
        let alert = UIAlertController(title: "Warning", message: "Do You Want To Delete Item?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            self.deleteFood(indexpath: indexpath)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteFood(indexpath : IndexPath){

        let index = self.foodData[indexpath.row]
        let id = index["menu_id"] as? String
        
        let param : [String : String] = ["id" : id!]
        
        Alamofire.request(Constant().BASE_URL_API + "deleteMakanan", method: .post, parameters: param,encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            let allJson = JSON(response.result.value as Any)
            let sukses = allJson["sukses"].boolValue
            let pesan = allJson["pesan"].stringValue
            
            if sukses{
                self.showAlert(title: "Sukses", message: pesan, isBackToPreviousPage: false)
                self.viewDidAppear(true)
            }
            else{
                self.showAlert(title: "Gagal", message: pesan, isBackToPreviousPage: false)
            }
        }
    }
    
    func showAlert(title : String, message : String, isBackToPreviousPage : Bool){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                var ok = UIAlertAction()
                
                if isBackToPreviousPage {
                    ok = UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
                else{
                   ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                }
                
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateFood" {
            if let tujuan = segue.destination as? UpdateViewController{
                
                let index = sender as! IndexPath
                let data = self.foodData[index.row]
                let name = data["menu_nama"] as? String
                let price = data["menu_harga"] as? String
                let image = data["menu_gambar"] as? String
                let id = data["menu_id"] as? String
                
                tujuan.id = id
                tujuan.name = name
                tujuan.price = price
                tujuan.image = image
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "updateFood" {
        return false
     }
    return true
   }
}
