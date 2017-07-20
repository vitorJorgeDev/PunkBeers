//
//  Rest.swift
//  StarWarsAPI
//
//  Created by Vitor Jorge on 24/06/17 RM 31624.
//  Copyright © 2017 Vitor. All rights reserved.
//

import Foundation
import UIKit

class REST {
    
    static let basePath = "https://api.punkapi.com/v2/beers"
    static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 4
        return config
    }()

    static let session = URLSession(configuration: configuration)
    
    // Load Beers
    static func loadBeers(onComplete: @escaping ([Beer]?) -> Void) {
        guard let url = URL(string: basePath) else {
            onComplete(nil)
            return
        }

        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                onComplete(nil)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200 {
                    
                    guard let data = data else {
                        onComplete(nil)
                        return
                    }
                    
                    let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! [[String:Any]]
                    var beers: [Beer] = []

                    for item in json{
                        
                        let beer: Beer = Beer()
                        if let id = item["id"] as? Int{beer.id = id }else{beer.id = 0}
                        if let name = item["name"] as? String{beer.name = name }else{beer.name = ""}
                        if let tagline = item["tagline"] as? String{beer.tagline = tagline }else{beer.tagline = ""}
                        if let description = item["description"] as? String{beer.description = description }else{beer.description = ""}
                        if let image_url = item["image_url"] as? String{beer.image_url = image_url }else{beer.image_url = ""}
                        if let abv = item["abv"] as? Float{beer.abv = abv }else{beer.abv = 0}
                        if let ibu = item["ibu"] as? Float{beer.ibu = ibu }else{beer.ibu = 0}
                        
                        /*
                        let id = item["id"] as! Int
                        let name = item["name"] as! String
                        let tagline = item["tagline"] as! String
                        let description = item["description"] as! String
                        let image_url = item["image_url"] as! String
                        let abv = item["abv"] as! Float
                        let beer = Beer(id: id, name: name, tagline: tagline, description: description, image_url: image_url, abv: abv)
                        let ibu = item["ibu"] as? Float
                        beer.ibu = ibu
                        */
                        
                        beers.append(beer)

                    }

                    onComplete(beers)
                    
                } else {
                    print(response.statusCode)
                    onComplete(nil)
                }
            }
        }.resume()
    }
    
    
    //Load Image
    static func loadImage(image_url: String, onComplete: @escaping (UIImage?) -> Void){
        guard let url = URL(string: image_url) else{
            onComplete(nil)
            return
        }
        
        session.downloadTask(with: url){(url: URL?, response: URLResponse?, error: Error?)  in
            if error != nil {
                onComplete(nil)
                
            }else{
                guard let response = response as? HTTPURLResponse else{
                    onComplete(nil)
                    return
                }
                if response.statusCode == 200{
                    
                    let imageData = NSData(contentsOf: url!)
                    let image = UIImage(data: imageData! as Data)
                    onComplete(image)
                    
                }else{
                    onComplete(nil)
                }
                
            }
        }.resume()
    }
}
    
