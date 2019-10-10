//
//  CarPickerVC.swift
//  TrunkFit
//
//  Created by Turner Thornberry on 10/9/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class CarPickerVC: UIViewController {
    
    // MARK: IBOutlet Vars
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: Internal Vars
    //var seriesNames = [String]()
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Collection View Delegate Methods

extension CarPickerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return SeriesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesCVCell", for: indexPath) as! SeriesCVCell
 //     cell.seriesLabel.text = SeriesNames[indexPath.row]
      return cell
    }
}
