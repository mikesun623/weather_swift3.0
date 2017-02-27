//
//  viewTwo.swift
//  weather_swift3.0
//
//  Created by mike on 2017/1/29.
//  Copyright © 2017年 my_application. All rights reserved.
//

import Foundation

//control the second screen
import UIKit

class ViewController2 : UIViewController, UISearchBarDelegate {
    
    @IBOutlet var miniDegree: UILabel! //mini degree lable
    
    @IBOutlet var maxDegree: UILabel! //max degree lable
    
    @IBOutlet var humidityLdl: UILabel! //humidity lable
    
    @IBOutlet var wind_speed: UILabel! //wind speed lable
    
    var mini:Float = 0.0
    var max:Float = 0.0
    var humidity:Float = 0
    var speed:Float = 0
    
    override func viewDidLoad() {
        
        miniDegree.text = "\(mini)"
        maxDegree.text = "\(max)"
        humidityLdl.text = "\(humidity)"
        wind_speed.text = "\(speed)"
        
    
    }
}
