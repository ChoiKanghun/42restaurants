//
//  ViewController.swift
//  42restaurants
//
//  Created by 최강훈 on 2021/07/20.
//

import UIKit
import NMapsMap

class ViewController: UIViewController {

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }


}

