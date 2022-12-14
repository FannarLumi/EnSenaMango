//
//  DictionaryViewController.swift
//  EnSena
//
//  Created by 조수연 on 2022/10/29.
//

import UIKit
import FirebaseFirestore
/*
import SwiftUI
struct DictionaryView: View {
    @available(iOS 13.0.0, *)
    var body: some View {
        NavigationView {
            List {
                ForEach(Category.allCases) { category in Text(category.rawValue + "s")}
            }
        }
    }
    
}
*/
class MyTapGesture: UITapGestureRecognizer {
    var category = String()
}

struct Response: Decodable {
        let categories: [Categories]
    }
struct Categories: Decodable {
    let words: [Words]
    let category: String
    }

struct Words: Decodable {
    let word: String
    let media: String
    }

class DictionaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var nameView: UITableView!

   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Dictionary.dummyDicCategory.count
    }
    
    @objc func labelTapped(_ sender: MyTapGesture) {
            //abrir un view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DictonaryDetailViewController") as! DictonaryDetailViewController
  
        vc.modalPresentationStyle = .fullScreen
        vc.category = sender.category
            self.present(vc, animated: true)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nameView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = Dictionary.dummyDicCategory[indexPath.row]
        cell.textLabel?.text = target.name
        //TODO: Asociar la acción del Tap (labelTapped) a un UIView en lugar de cell.textLabel
        //TODO: si no es posible, cambiar el width del label para que tome el mismo tamaño de la vista
            //Programatically Tapped Action
            let labelTap = MyTapGesture(target: self, action: #selector(self.labelTapped(_:)))
            cell.textLabel!.isUserInteractionEnabled = true
            cell.textLabel!.addGestureRecognizer(labelTap)
            labelTap.category = target.name
            //Programatically Tapped Action
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //nameView.reloadData()
        
        //BUSCAR LOS DATOS EN FIREBASE
        
        let db = Firestore.firestore()
        //var Information: [String:Any]?
    
        
        db.collection("DICTIONARY").getDocuments { (querySnapshot, error) in
                        for document in querySnapshot!.documents {
                            let data: [String:Any] = document.data()
                            let categories = data["categories"] as? Array<Any>
                            for index in 0...categories!.count-1
                            {
                                let dataCategories = categories![index] as? [String: Any]
                                let category = dataCategories!["category"]
                                let newCategory = Dictionary(name: (category) as! String)
                                Dictionary.dummyDicCategory.append(newCategory)
                            }
//                            for category in categories {
//                                let data = category["category"]
//                                let newCategory = Dictionary(name: data)
//                                Dictionary.dummyDicCategory.append(newCategory)
//                            }
                        }
        }
       // print(#function)
    }
    var token: NSObjectProtocol?
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(forName: DictionaryCompseViewController.newDicDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in self?.nameView.reloadData()}

        
        // Do any additional setup after loading the view.
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
