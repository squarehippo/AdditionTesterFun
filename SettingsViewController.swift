//
//  SettingsViewController.swift
//  AdditionTesterFun
//
//  Created by Brian Wilson on 2/22/17.
//  Copyright © 2017 GetRunGo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIBarButtonItem) {
    }

    @IBAction func bbtnCancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
