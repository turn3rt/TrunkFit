//
//  HomeVC.swift
//  TrunkFit
//
//  Created by Turner Thornberry on 10/9/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit

class HomeVC: UIViewController {

    // MARK: IBOutlet Vars
       @IBOutlet weak var myBMWlabel: UILabel!
       @IBOutlet weak var myBMWbutton: UIButtonX!

    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        let myBMWint = UserDefaults.standard.integer(forKey: "myBMW")
        myBMWlabel.text = DemoModalNames[myBMWint]
        myBMWbutton.setImage(UIImage(named: "bmw\(myBMWint+1).jpeg"), for: .normal)
    }
    
    
    
    
    let userDefaults = UserDefaults.standard
    
//    func getCurrentCar() -> Int { // returns integer value corresponding to a specific car model
//        let myBMW = UserDefaults.standard.integer(forKey: "myBMW")
//
//        return myBMW
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
