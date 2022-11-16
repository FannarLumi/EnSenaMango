//
//  ViewController.swift
//  EnSena
//
//  Created by 조수연 on 2022/09/26.
//

import UIKit
import Firebase
import SwiftUI

class LoginViewController: UIViewController {

   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        
    }

    @IBOutlet weak var id: UITextField!
    
    @IBOutlet weak var pw: UITextField!
    
   
    func login(){
        Auth.auth().signIn(withEmail: id.text!, password: pw.text!) { (user,error) in
            if let error = error {
                print(error.localizedDescription)
          }
            else{
                print("OK")
                
                
                let db = Firestore.firestore()
                var information: [String:Any]?
            
                db.collection("USER").order(by: "id").getDocuments { (querySnapshot, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    
                }
                else {
                    information = QuerySnapshot!.documents.first?.data()
                    
                    var tipo: String = Information["admin"] as! int
                        if self.tipo == 0 {
                            self.performSegue(withIdentifier: StringAdminSegue, sender: nil)
                        }
                           
                        /*else{
                            self.tfEmail.text = ""
                            self.tfPassword.text = ""
                            
                            let alerta = UIAlertController(title: "Error", message: "El usuario o contraseña son incorrectos", preferredStyle: .alert)
                            
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            alerta.addAction(action)
                            self.present(alerta, animated: true, completion: nil)
                        }*/
                    }
                }}
            }
        }
    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    
   
    
}

