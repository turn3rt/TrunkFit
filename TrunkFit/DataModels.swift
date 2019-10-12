//
//  DataModels.swift
//  TrunkFit
//
//  Created by Turner Thornberry on 10/9/19.
//  Copyright © 2019 personal. All rights reserved.
//

import Foundation
import UIKit



let SeriesNames = ["P", "1", "2", "3", "4", "5", "6", "7", "8", "X", "Z", "M", "i"]

let DemoModalNames = ["X4", "X5", "i3"]



// MARK: - App Wide Functions
func makeNavBarTransparent(controller: UIViewController) {
    controller.navigationController?.navigationBar.isHidden = false
    controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    controller.navigationController?.navigationBar.shadowImage = UIImage()
    controller.navigationController?.navigationBar.isTranslucent = true
}

// converts degrees to radians
func deg2rad(_ number: Float) -> Float {
    return number * .pi / 180
}
