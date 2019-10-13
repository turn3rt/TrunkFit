//
//  CarPickerVC.swift
//  TrunkFit
//
//  Created by Turner Thornberry on 10/9/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class CarPickerVC: UIViewController {
    
// MARK: IB Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

// MARK: Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
// MARK: Internal Vars & Constants
    var modelImages = [UIImage]()
    let userDefaults = UserDefaults.standard
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
            cell.seriesLabel.font = cell.seriesLabel.font.withSize(32)
        } else {
            cell.seriesLabel.textColor = .black
            cell.seriesLabel.font = cell.seriesLabel.font.withSize(42)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("user selected: \(indexPath)")
        userDefaults.set(indexPath.row, forKey: "myBMW")

        navigationController?.popViewController(animated: true)
    }
}
