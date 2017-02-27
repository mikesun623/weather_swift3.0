//
//  ViewController.swift
//  weather_swift3.0
//
//  Created by mike on 2017/1/28.
//  Copyright © 2017年 my_application. All rights reserved.
//

import UIKit
//this age conrol the first screen
class ViewController: UIViewController, UISearchBarDelegate {


    @IBOutlet var button: UIButton! //control the button in the first screen

    @IBOutlet var searchBar: UISearchBar! //the search bar
    //labels on first screen
    @IBOutlet var cityLbl: UILabel!
    
    @IBOutlet var conditionLbl: UILabel!
    
    @IBOutlet var degreeLbl: UILabel!
    
    @IBOutlet var loading: UILabel!
    
    @IBOutlet var imgView: UIImageView!
    //self data of variables
    var degree: Int!
    var condition: String!
    var imgurl: String!
    var city: String!
    
    var cod: String!
    var min:Float=0
    var max:Float=0
    var humidity:Float=0
    var wind_speed:Float=0
    
    var exists: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate=self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.loading.isHidden = false
        
        //creat and visit url
        let urlRequest = URLRequest(url:URL(string:"http://api.openweathermap.org/data/2.5/weather?q=\(searchBar.text!)&units=metric&APPID=5933986010b65a4181c8994f3d137bb2")!)
        
        
        //get data from the api
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    //visit root mian
                    if let current = json["main"] as? [String : AnyObject]{
                        if let temp = current["temp"] as? Int{
                            self.degree = temp
                            self.min = current["temp_min"] as! Float
                            self.max = current["temp_max"] as! Float
                            self.humidity = current["humidity"] as! Float
                        }
                        self.exists = true
                    }
                    //visit root wind
                    if let current = json["wind"] as? [String : AnyObject]{
                        if let speed = current["speed"] as? Float{
                            self.wind_speed = speed
                        }
                        self.exists = true
                    }
                    
                        //visit root weather
                    if let weather = json["weather"] as? NSArray{
                            if let value = weather[0] as? NSDictionary{
                                if let description = value["description"] as? String{
                                    
                                    self.condition=description
                                    let icon = value["icon"] as! String
                                    self.imgurl = "http://openweathermap.org/img/w/\(icon)"+".png"
                                    self.city = json["name"] as! String
                                }
                            }
                        self.exists = true
                        }
                    //set visitable of the lables and put them to output on the screen
                    DispatchQueue.main.async {
                        if self.exists{
                            self.loading.isHidden = true
                            self.degreeLbl.isHidden = false
                            self.conditionLbl.isHidden = false
                            self.imgView.isHidden = false
                            self.cityLbl.isHidden = false
                            self.button.isHidden = false
                            
                            
                            self.degreeLbl.text = "\(self.degree.description)°"
                            self.cityLbl.text = self.city
                            self.conditionLbl.text = self.condition
                            self.imgView.downloadImage(from: self.imgurl!)
                        }else{
                            self.button.isHidden = true
                            self.loading.isHidden = true
                            self.degreeLbl.isHidden = true
                            self.conditionLbl.isHidden = true
                            self.imgView.isHidden = true
                            self.cityLbl.text = "no maching city found"
                           // self.exists = true
                        }
                    }
                    
               // }
                } catch let jsonError{
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
        
        
    }
    //set data for the second screen
    override func prepare( for segue: UIStoryboardSegue, sender: Any?) {
            let DestViewController = segue.destination as! ViewController2
            DestViewController.mini = min
            DestViewController.max = max
            DestViewController.humidity=humidity
            DestViewController.speed=wind_speed
        }
}

extension UIImageView{
    func downloadImage(from url: String){
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest){(data,reponse,error)in
            if error == nil{
                DispatchQueue.main.async{
                    self.image = UIImage(data:data!)
                }
            }
        }
        
        task.resume()
        
    }
}

