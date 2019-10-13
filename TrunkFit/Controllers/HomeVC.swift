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
}
