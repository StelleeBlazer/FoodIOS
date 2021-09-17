//
//  UpdateViewController.swift
//  Food IOS
//
//  Created by Mac n Cheese on 24/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class UpdateViewController: UIViewController {

    @IBOutlet weak var imgUpdate: UIImageView!
    @IBOutlet weak var tfUpdateName: UITextField!
    @IBOutlet weak var tfUpdatePrice: UITextField!
    @IBOutlet weak var tfUpdateImage: UITextField!
    
    var id : String?
    var name : String?
    var price : String?
    var image : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfUpdateName.text = name
        tfUpdatePrice.text = price
        tfUpdateImage.text = image
        
        Alamofire.request(image!).response { (dataImage) in
            self.imgUpdate.image = UIImage(data: dataImage.data!)
        }
    }
    @IBAction func btnUpdateFood(_ sender: UIButton) {
        
        if tfUpdateName.text!.count < 0 || tfUpdatePrice.text!.count < 0 || tfUpdateImage.text!.count < 0 {
            showAlert(title: "Warning", message: "Cannot Be Null", isBackToPreviousPage: false)
        }
        else{
            updateFood(id: id!, name: tfUpdateName.text!, price: tfUpdatePrice.text!, image: tfUpdateImage.text!)
                
           }
        }
    
        func updateFood(id : String, name : String, price : String, image : String) {
                
        let param : [String : String] = ["id" : id,
                                         "nama" : name,
                                         "harga" : price,
                                         "gambar" : image]
                
                
                Alamofire.request(Constant().BASE_URL_API + "updateMakanan", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
                    
                let allJson = JSON(response.result.value as Any)
                let sukses = allJson["sukses"].boolValue
                let pesan = allJson["pesan"].stringValue
                    
                    if sukses{
                        self.showAlert(title: "Sukses", message: pesan, isBackToPreviousPage: true)
                    }
                    else{
                        self.showAlert(title: "Gagal", message: pesan, isBackToPreviousPage: false)
                    }
                }
            }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
    
    

}
