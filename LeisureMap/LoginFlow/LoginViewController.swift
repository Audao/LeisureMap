//
//  LoginViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController , UITextFieldDelegate,AsyncResponseDelegaate,FlieWorkerDelegate{
    
  

    
    

    
    var requestWorker : AsyncRequestWorker?
    var fileWorker : FileWorker?
    let storeFileName : String = "store.json"
    
    @IBOutlet weak var txtAccount: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK: - View's Event
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        requestWorker = AsyncRequestWorker()
        requestWorker?.responseDelegate = self
        fileWorker = FileWorker()
        fileWorker?.FlieWorkerDelegate = self
        

        
//        let from = "https://score.azurewebsites.net/api/version/(  String( describing :appVersion) )"
//
//
//        self.requestWorker?.getResponse(from: from, tag: 1)
        
        
        print("viewDidload")
        
        
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewDidAppear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewDidDisappear")
    }
    
    //MARK: -UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //
        
        let accept = "abcdeABCDE"
        let cs = NSCharacterSet(charactersIn: accept).inverted
        //['a','b','c']
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        //["a","b","c"]
        if (string != filtered){
            return false
        }
        
        
        //Max Length
        var maxLength : Int = 0
        
        if textField.tag == 1{
            maxLength = 4
            
            
        }
        if textField.tag == 3{
            maxLength = 5
            
        }
        let currentString : NSString = textField.text! as NSString
        let newString : NSString = currentString.replacingCharacters(in: range, with:  string) as NSString
        return newString.length <= maxLength
        

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1{
            textField.resignFirstResponder()
            txtPassword.becomeFirstResponder()
        }
        if textField.tag == 2{
            textField.resignFirstResponder()
            
        }
    return true
    }
    //MARK: -AsyncResponseDelegaate
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        
        let account = txtAccount.text!
        let password = txtPassword.text!
        
        let from = "https://score.azurewebsites.net/api/login/\(account)/\(password)"
        self.requestWorker?.getResponse(from: from, tag: 1)
        
    }
    
    func readServieCategory() {
        let from = "https://score.azurewebsites.net/api/ServiceCategory"
        self.requestWorker?.getResponse(from: from, tag: 2)
    }
    
    func readStore() {
        let from = "https://score.azurewebsites.net/api/Store"
        self.requestWorker?.getResponse(from: from, tag: 3)
    }
    
    func receivedResponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        
       // print("\( tag ):\(responseString)")
        
        switch tag {
            
        case 1:
            //login
            self.readServieCategory()
            break
        case 2:
           
            //ServiceCategory
            
            do{
                if let dataFromString = responseString.data(using: .utf8, allowLossyConversion: false) {

                    let json = try JSON(data: dataFromString)

                    let sqliteContext = SQLiteWorker()

                    sqliteContext.createDatabase()

                    sqliteContext.clearAll()



                    for (_,subJson):(String, JSON) in json {


                        let name : String  = subJson["name"].stringValue
                        let imagePath : String  = subJson["imagePath"].stringValue

                        sqliteContext.insertData(_name: name, _imagepath: imagePath)


                    }
                    let categories = sqliteContext.readData()
                    print(categories)
                }
            }catch{
                print(error)
            }

            
            self.readStore()
            break
        case 3:
           //
           
//            do{
//                if let dataFromString = responseString.data(using: .utf8, allowLossyConversion: false) {
//
//                    let json = try JSON(data: dataFromString)
//
//                    for (_,subJson):(String, JSON) in json {
//
//                        let ServiceIndex : Int = subJson["serviceIndex"].intValue
//                        let name : String  = subJson["name"].stringValue
//                        let index : Int = subJson["index"].intValue
//                        let imagePath : String  = subJson["imagePath"].stringValue
//
//                        let location : JSON  = subJson["location"]
//                        let latitude : Double =  location["latitude"].doubleValue
//                        let longitude : Double = location["longitude"].doubleValue
//                        print("\( index ):\( name ):latitude:\( latitude )")
//
//
//                    }
//                }
//            }catch{
//                print(error)
//            }
            
            self.fileWorker?.writeToFile(content: responseString, fileName: storeFileName, tag: 1)
            
            
            //Store
           
            break
        default:
            break
        }
        
    }
    
    //MARK : -FileWorkerDelegate
    func fileWorkWriteCompleted(_ sender: FileWorker, fileName: String, tag: Int) {
        print(fileName)
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToMasterviewSegue", sender: self)
        }
    }
    
    func fileWorkReadCompleted(_ sender: FileWorker, content: String, tag: Int) {
        
    }

}
