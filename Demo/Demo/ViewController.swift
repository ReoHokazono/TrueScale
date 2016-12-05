//
//  ViewController.swift
//  Demo
//
//  Created by Reo Hokazono on 2016/12/05.
//  Copyright © 2016年 Reo Hokazono. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = TSRect(x: 10, y: 10, width: 20, height: 20, unit: .mm).cgrect
        let square = UIView(frame: frame)
        square.backgroundColor = UIColor.darkGray
        view.addSubview(square)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

