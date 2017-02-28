//
//  DetailedAlphabetsViewController.swift
//  LearningToSpeakAlphabets
//
//  Created by Sanika Kulkarni on 2/19/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit
import AVFoundation

//This class displays all details related to an alphabet
class DetailedAlphabetsViewController: UIViewController {

    let alphabets = "abcdefghijklmnopqrstuvwxyz"
    let items = ["for apple", "for ball", "for cat", "for dog", "for elephant", "for frog", "for giraffe", "for hat", "for ice-cream", "for jeep", "for kite", "for lion", "for mango", "for nose", "for orange", "for parrot", "for queen", "for rat", "for sun", "for tiger", "for umbrella", "for van", "for watermelon", "for x-mas tree", "for yak", "for zebra"]
    
    @IBAction func listen(_ sender: Any) {
        
        //Split string into two strings because , strings are not proper sentences. 
        //Which causes improper utterence of string
        
        let letterString = alphabets[alphabets.index(alphabets.startIndex, offsetBy: selectedAlphabet)]
        let synth = AVSpeechSynthesizer()
        let myUtterance = AVSpeechUtterance(string: String(letterString))
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
        let myUtterance1 = AVSpeechUtterance(string: items[selectedAlphabet])
        myUtterance1.rate = 0.5
        synth.speak(myUtterance1)
    }
    
    @IBOutlet weak var alphabetImage: UIImageView!
    var selectedAlphabet: Int!
    @IBOutlet weak var alphabetText: UIImageView!
    @IBOutlet weak var alphabetLetter: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageName : String! = "\(selectedAlphabet!).png"
        alphabetText.image = UIImage(named: imageName)
        imageName = "\(selectedAlphabet!)i.png"
        alphabetLetter.image = UIImage(named: imageName)
        imageName = "\(selectedAlphabet!)ii.png"
        alphabetImage.image = UIImage(named: imageName)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
