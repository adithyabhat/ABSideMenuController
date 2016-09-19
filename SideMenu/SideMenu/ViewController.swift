//
//  ViewController.swift
//  SideMenu
//
//  Created by Bhat, Adithya H (external - Project) on 9/18/16.
//  Copyright © 2016 AB. All rights reserved.
//

import UIKit

class ViewController: ABSideMenuViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.lightGray
        self.sideMenuViewController = vc1
        
        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SampleContentViewController")
        self.contentViewController = vc2
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.toggleCenterContentView()
    }
    
}

