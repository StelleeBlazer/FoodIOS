//
//  LoginViewController.swift
//  Food IOS
//
//  Created by Mac n Cheese on 25/07/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var tfLoginEmail: UITextField!
    @IBOutlet weak var tfLoginPassword: UITextField!
    
    
    var userDefaultLogin = UserDefaults.standard
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func btnLogin(_ sender: Any) {
        if tfLoginEmail.text!.count < 0 || tfLoginPassword.text!.count < 0{
            showAlert(title: "Warning", message: "Cannot Be Null", isBackToPreviousPage: false)
        }
        else{
            login(email: tfLoginEmail.text!, password: tfLoginPassword.text!)
        }
    }
    
    func login(email : String, password : String){
        
        let param : [String : String] = ["email" : email,
                                         "password" : password]
        
        Alamofire.request(Constant().BASE_URL_API + "login", method: .post, parameters: param, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            
            let allJson = JSON(response.result.value as Any)
            let sukses = allJson["sukses"].boolValue
            let pesan = allJson["pesan"].stringValue
            
            if sukses{
                
                // simpan value ke UserDefault
                self.userDefaultLogin.setValue(true, forKey: Constant().KEY_LOGIN)
                
                //
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destination = storyboard.instantiateViewController(identifier: "navigationFood")
                self.show(destination, sender: self)
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
    
    @IBAction func btnToPageRegister(_ sender: Any) {
        
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
