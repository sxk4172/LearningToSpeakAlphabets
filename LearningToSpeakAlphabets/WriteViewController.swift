//
//  WriteViewController.swift
//  LearningToSpeakAlphabets
//
//  Created by Sanika Kulkarni on 2/21/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "writeCell"
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in (0..<26) {
            items.append("\(i)i.png")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count

    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! WriteAlphabetCollectionViewCell
        let imageName = self.items[indexPath.item]
        cell.alphImg.image = UIImage(named: imageName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailedWriteViewController") as! DetailedWriteViewController
        vc.selectedAlphabetNumber = indexPath.item
        self.present(vc, animated: true, completion: nil)
       
    }


}
