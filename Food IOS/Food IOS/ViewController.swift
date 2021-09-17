//
//  ViewController.swift
//  Food IOS
//
//  Created by Mac n Cheese on 24/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var tfinsertName: UITextField!
    @IBOutlet weak var tfinsertPrice: UITextField!
    @IBOutlet weak var tfinsertImage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnInsertFood(_ sender: UIButton) {
        
        if tfinsertName.text!.count < 0 || tfinsertPrice.text!.count < 0 || tfinsertImage.text!.count < 0 {
            showAlert(title: "Warning", message: "Cannot Be Null", isBackToPreviousPage: false)
        }
        else{
            insertFood(name: tfinsertName.text!, price: tfinsertPrice.text!, image: tfinsertImage.text!)
        }
    }
    func insertFood(name : String, price : String, image : String){
        
        let param : [String : String] = ["nama" : name,
                                         "harga" : price,
                                         "gambar" : image]
        
        Alamofire.request(Constant().BASE_URL_API + "insertMakanan", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
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

