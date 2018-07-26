//
//  SplashViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/23.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,AsyncResponseDelegaate {
  
    var requestWorker : AsyncRequestWorker?
    var appVersion : String = ""

    @IBOutlet weak var lbVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 
        
      
        
        //
        appVersion = "" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        lbVersion.text = appVersion
        
        //
        requestWorker = AsyncRequestWorker()
        requestWorker?.responseDelegate = self
        
        let from = "https://score.azurewebsites.net/api/version/\(  String( describing :appVersion) )"
        
        
        self.requestWorker?.getResponse(from: from, tag: 1)
//        let url = URL(string: from)!
//        let request = URLRequest(url : url)
//
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration:config)
//        let task = session.dataTask(with: request, completionHandler: {(data,response,error) in
//
//        let httpResponse = response as!HTTPURLResponse
//        let statusCode = httpResponse.statusCode
//
//        if(200 == statusCode){
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//
//            let responseString = String(dataString!)
//
//            print(responseString)
//            }
//        })
//        task.resume()
        
  
        
    }
    
    //MARK: AsyncResponseDelegaate
    
    func receivedResponse(_ sender: AsyncRequestWorker, responseString: String, tag: Int) {
        print(responseString)
        
        //
        let defaults:UserDefaults =  UserDefaults.standard
        
        defaults.set(responseString, forKey: "serviceVersion")
        
        defaults.synchronize()
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToLoginViewSegue", sender: self)        }
    }

}
