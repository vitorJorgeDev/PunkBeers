//
//  BeersTableViewController.swift
//  PUNKBeers
//
//  Created by Vitor Cesar Hideo Jorge on 03/07/17.
//  Copyright © 2017 Vitor Cesar Hideo Jorge RM 31624. All rights reserved.
//

import UIKit

class BeersTableViewController: UITableViewController {
    
    // MARK: Variables
    var dataSource: [Beer] = []
    var flag: Int = 0
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let subBarView = UIView()
    let subBarViewInto = UIView()
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        internetConnection()
        
    }
    
    // MARK: Methods
    // Check internet connection
    func internetConnection(){
        
        if(!Reachability.isConnectedToNetwork()){
           
            let alert = UIAlertController(title: "No Internet", message: "Please, check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    
                    self.internetConnection()
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            loadBeers()
            setLoadingScreen()
        }

    }
    
    
    func loadBeers() {
        REST.loadBeers { (beers: [Beer]?) in
            if let beers = beers {
                
                self.dataSource = beers
                self.loadImages()
            
            }
        }
    }
    
    func loadImages(){
    
        for item in dataSource{
            
            if (item.image_url != ""){
            
                REST.loadImage(image_url: item.image_url!, onComplete: { (image) in
                    item.image = image
                    DispatchQueue.main.async {
                        
                        self.flag += 1
                        print("LoadImages \(self.flag)")
                        
                        self.changeLoadingBar()
                        
                        if(self.flag == self.dataSource.count){
                            self.tableView.reloadData()
                            
                            self.removeLoadingScreen()
                            
                        }
                    }
                })

            } 
        }
    }
    
    // Send object to viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       let vc = segue.destination as! ViewController
        vc.beer =  dataSource[tableView.indexPathForSelectedRow!.row]
    }
    
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 150
        let height: CGFloat = 60
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
        
        // sets a views bar
        let widthSubBar: CGFloat = 100
        let heightSubBar: CGFloat = 10
        self.subBarView.frame = CGRect(origin: CGPoint(x: 20, y: 35), size: CGSize(width: widthSubBar, height: heightSubBar))
        self.subBarView.backgroundColor = .none
        self.subBarView.layer.cornerRadius = heightSubBar / 2
        self.subBarView.layer.borderWidth = 1
        self.subBarView.layer.borderColor = UIColor.black.cgColor
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        
        self.loadingLabel.frame = CGRect(origin: CGPoint(x: 4, y: 0), size: CGSize(width: 150, height: 30))
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.color = .black
        self.spinner.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30))
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.subBarView)
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableView.addSubview(loadingView)
        
        changeLoadingBar()
        
    }
    
    private func changeLoadingBar(){
    
        // Sets view inside the bar
        let widthSubBarInto: CGFloat!
        
        if (dataSource.count == 0 ){
            widthSubBarInto  =  (CGFloat((100 * flag) / 1))
        }else{
            widthSubBarInto  =  (CGFloat((100 * flag) / dataSource.count))
        }
        
        let heightSubBarInto: CGFloat = 8
        self.subBarViewInto.frame = CGRect(origin: CGPoint(x: 0, y: 1), size: CGSize(width: widthSubBarInto, height: heightSubBarInto))
        self.subBarViewInto.backgroundColor = .blue
        self.subBarViewInto.layer.cornerRadius = heightSubBarInto / 2
        self.subBarView.addSubview(subBarViewInto)

    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        self.subBarView.isHidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BeerTableViewCell
        let beer = self.dataSource[indexPath.row]
        
        cell.lbName.text = beer.name
        
        if beer.abv == 0{cell.lbAbv.text = "None"}else{if let abv = beer.abv{cell.lbAbv.text = "\(abv)"}}
        
        cell.ivBeerImage.image = beer.image
        print("passou")
        
        return cell
    }

}
