//
//  ViewController.swift
//  SLoader
//
//  Created by Shweta Vani on 08/11/17.
//  Copyright © 2017 Shweta Vani. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

  //MARK:- Viewcontroller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //default behaviour of loader
        Loader.sharedInstance.showLoader()
        
        //for customization of loader you can access properties of loader
//        let loader = Loader.sharedInstance
//        loader.animatedColor = UIColor.red
//        loader.backgroundColor = UIColor.black
//        loader.movingCircleColor = UIColor.yellow
//        loader.circleColor = UIColor.blue
//        loader.loadingTextColor = UIColor.cyan
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Loader.sharedInstance.stopLoader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    

  
}




