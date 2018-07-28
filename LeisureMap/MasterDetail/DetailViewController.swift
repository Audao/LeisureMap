//
//  DetailViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/25.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectdStore : Store?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = selectdStore?.Name
    }
    

    @IBAction func btnMapClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToMapViewSegue", sender: self)
        }
        
    }
    
    
    @IBAction func btnwebClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToNoteViewSegue", sender: self)
        }
        
    }
    
    
    
  
    // MARK: - Navigation

    override func  prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "moveToMapViewSegue":
            
            break
        case "moveToNoteViewSegue":
            
            break
            
        default:
            break
        }
    }

}
