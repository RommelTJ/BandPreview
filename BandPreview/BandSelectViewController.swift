//
//  BandSelectViewController.swift
//  BandPreview
//
//  Created by Rommel Rico on 2/15/15.
//  Copyright (c) 2015 Rommel Rico. All rights reserved.
//

import UIKit

class BandSelectViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var myBandSelectLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        //let sc = SearchResultsViewController()
        //self.presentViewController(sc, animated: true, completion: nil)
        //TODO: Go to another view.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        // close the keyboard on Go
        textField.resignFirstResponder()
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "bandSegue") {
            var srvc = segue.destinationViewController as SearchResultsViewController;
            srvc.bandName = myBandSelectLabel.text
        }
    }

}
