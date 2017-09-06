//
//  ViewController.swift
//  JSCore-IPQuery-Demo
//
//  Created by 梁宪松 on 2017/9/6.
//  Copyright © 2017年 Madao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addressInputFiled: UITextField!
    @IBOutlet weak var resultDisplayLabel: UILabel!
    
    var ipInfo: IPInfo? {
        didSet {
            guard let country = self.ipInfo?.country,
                let province = self.ipInfo?.province,
                let city = self.ipInfo?.city,
                let district = self.ipInfo?.district
                else {
                    print("Can not map IPInfo Items")
                    return
            }
            OperationQueue.main.addOperation {
                
                self.resultDisplayLabel.text = "Country:\(country)\nProvince:\(province)\nCity:\(city)\nDistrict:\(district)\n"
                
            }
        }
    }
    
    let ipService = IPService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addressInputFiled.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController : UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let ipAddress = textField.text else {
            return
        }
        // [weak self] 弱引用写法
        ipService.fetchIpInfo(ip: ipAddress){
            
            [weak self] (ipInfo) in
            self?.ipInfo = ipInfo
        }
    }
}

