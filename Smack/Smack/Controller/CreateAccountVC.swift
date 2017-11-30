//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Kevin Keefe on 11/29/17.
//  Copyright © 2017 Kevin Keefe. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closedPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
