//
//  HomeViewController.swift
//  AdditionTesterFun
//
//  Created by Brian Wilson on 2/22/17.
//  Copyright © 2017 GetRunGo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        defaults.set("ones", forKey: "Places")
        
        print("Loading defaults")
    }
    
    @IBAction func startAction(_ sender: UIButton) {
        
    }

}
