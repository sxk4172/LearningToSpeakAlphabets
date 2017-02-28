//
//  AlphabetsViewController.swift
//  LearningToSpeakAlphabets
//
//  Created by Sanika Kulkarni on 2/19/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit


//This class is used to display a list of alphabets on clicking "START"

class AlphabetsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell"
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to display all alphabets
        for i in (0..<26) {
            items.append("\(i)i.png")
        }
        
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! AlphabetsCollectionViewCell
        let imageName = self.items[indexPath.item]
        cell.alphabets.image = UIImage(named: imageName)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        let next = self.storyboard!.instantiateViewController(withIdentifier: "DetailedAlphabetsViewController") as! DetailedAlphabetsViewController
        next.selectedAlphabet = indexPath.item
        self.present(next, animated: true, completion: nil)
    }
}
