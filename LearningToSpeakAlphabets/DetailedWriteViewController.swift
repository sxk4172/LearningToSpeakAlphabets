//
//  DetailedWriteViewController.swift
//  LearningToSpeakAlphabets
//
//  Created by Sanika Kulkarni on 2/21/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit

class DetailedWriteViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    //
    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    //
    
    @IBOutlet weak var letterImage: UIImageView!
    
    var selectedAlphabetNumber: Int!
    var colorSketch: UIColor!
    
    @IBAction func colocPick(_ sender: UIButton) {

        let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self
            popoverVC.popoverPresentationController!.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    // Override the iPhone behavior that presents a popover as fullscreen
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }

    
    @IBAction func erase(_ sender: Any) {
        let imageName : String! = "i\(selectedAlphabetNumber!)i.png"
        letterImage.image = UIImage(named: imageName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        red   = (0.0/255.0)
        green = (0.0/255.0)
        blue  = (0.0/255.0)
        let imageName : String! = "i\(selectedAlphabetNumber!)i.png"
        letterImage.image = UIImage(named: imageName)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Touch events
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        isSwiping    = false
        if let touch = touches.first{
            lastPoint = touch.location(in: letterImage)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        
        isSwiping = true;
        if let touch = touches.first{
            let currentPoint = touch.location(in: letterImage)
            UIGraphicsBeginImageContext(self.letterImage.frame.size)
            self.letterImage.image?.draw(in: CGRect(x: 0, y: 0, width: self.letterImage.frame.size.width, height: self.letterImage.frame.size.height))
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
            if let userSelectedColorData  = UserDefaults.standard.object(forKey: "UserSelectedColor") as? NSData {
                if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data) as? UIColor {
                    UIGraphicsGetCurrentContext()?.setStrokeColor(userSelectedColor.cgColor)
                }
                else {
                    UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)

                }
            }
            UIGraphicsGetCurrentContext()?.strokePath()
            self.letterImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?){
        if(!isSwiping) {
            // This is a single touch, draw a point
            UIGraphicsBeginImageContext(self.letterImage.frame.size)
            self.letterImage.image?.draw(in: CGRect(x: 0, y: 0, width: self.letterImage.frame.size.width, height: self.letterImage.frame.size.height))
            UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
            if let userSelectedColorData  = UserDefaults.standard.object(forKey: "UserSelectedColor") as? NSData {
                if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data) as? UIColor {
                    UIGraphicsGetCurrentContext()?.setStrokeColor(userSelectedColor.cgColor)
                }
                else {
                    UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                    
                }
            }
            UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            UIGraphicsGetCurrentContext()?.strokePath()
            self.letterImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
}

