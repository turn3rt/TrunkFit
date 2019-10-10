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
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // load model images
        for i in 1...DemoModalNames.count {
            let image = UIImage(named: "bmw\(i).jpeg")
            self.modelImages.append(image!)
        }
    }
    
    // MARK: Internal Vars
    var modelImages = [UIImage]()
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CollectionView Delegate Methods
extension CarPickerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return SeriesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesCVCell", for: indexPath) as! SeriesCVCell
        cell.seriesLabel.text = SeriesNames[indexPath.row]
        
        if indexPath.row != 0 {
            cell.seriesLabel.textColor = .lightGray
        } else {
            cell.seriesLabel.font = cell.seriesLabel.font.withSize(32)
        }
        return cell
    }
}

// MARK: - TableView Delegate Methods
extension CarPickerVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemoModalNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ModelImage", for: indexPath) as! ModelTVCell
        cell.modelImage.image = modelImages[indexPath.row]
        cell.modelName.text = DemoModalNames[indexPath.row]

        return cell
    }
    
    
    
    
}