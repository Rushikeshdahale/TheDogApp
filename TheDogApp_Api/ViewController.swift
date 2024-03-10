//
//  ViewController.swift
//  TheDogApp_Api
//
//  Created by Rushikesh Dahale on 10/03/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dogListTableView: UITableView!
    var dogBreedNameArray:[String] = []
    let dogTableViewcellIdentifier :String = "dogTableViewCell"
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchDogsName()
        registerXIBWithPostTableView()
        dogListTableView.dataSource = self
        dogListTableView.delegate = self
       
    }
    
    func registerXIBWithPostTableView(){
        let uiNib = UINib(nibName: dogTableViewcellIdentifier, bundle: nil)
        dogListTableView.register(uiNib, forCellReuseIdentifier: dogTableViewcellIdentifier)
    }
    
    func fetchDogsName() {
        let url = URL.init(string: "https://dog.ceo/api/breeds/list/all")
        var request = URLRequest.init(url: url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            
            do{
                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                print(jsonDict!)

                let messageDict = jsonDict?["message"] as? [String:Any]
                
                for (key,value) in messageDict!{
                    if let values = value as? [String], values.count > 0{
                        for item in values{
                            let breedFullName = item + " " + key
                            self.dogBreedNameArray.append(breedFullName)
                        }
                    }else{
                        self.dogBreedNameArray.append(key)
                    }
                }
               
                DispatchQueue.main.async {
                    self.dogListTableView.reloadData()
                }
                
            }
            catch{
                print(error)
            }
        }
        task.resume()
 
    }
    
    func showDogImage(dogName:String, imageView:UIImageView){
            let str = "https://dog.ceo/api/breed/\(dogName)/images/random".lowercased()
        print(str)
        let urlString = str.replacingOccurrences(of: " ", with: "")
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            print(url!)
            
            if data != nil {
                let dict = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)as? [String:String]
                
                guard dict != nil else {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(named: "paw.")
                    }
                    return
                }
                
                let message = dict!["message"] as? String
                
                let urlImage = URL(string: message ?? "")
                if urlImage != nil{
                    let imageData = try? Data(contentsOf: urlImage!)
                    
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: imageData!)
                    }
                }
            }
        }.resume()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogBreedNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dogListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "dogTableViewCell", for: indexPath) as! dogTableViewCell
        dogListTableViewCell.dogNameLabel.text = dogBreedNameArray[indexPath.row]
        showDogImage(dogName: dogBreedNameArray[indexPath.row], imageView: dogListTableViewCell.dogImageView)
        return dogListTableViewCell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    

}

