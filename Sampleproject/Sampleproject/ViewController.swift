//
//  ViewController.swift
//  Sampleproject
//
//  Created by vishnu.kumar on 23/06/18.
//  Copyright © 2018 appmantras. All rights reserved.
//

import UIKit
    
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
   
    @IBOutlet weak  var searchbar: UISearchBar!
     @IBOutlet weak  var tablevieww: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "HOME"
        searchbar.delegate = self
//        tablevieww.estimatedRowHeight = 50.0
//        tablevieww.rowHeight = UITableViewAutomaticDimension
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
  cell.title.text = Tabletitlearray[indexPath.row] as! String
 cell.descriptionn.text = Tabledescriptionarray[indexPath.row] as! String
 cell.imagevieww.downloadedFrom(link: Tableimagearray[indexPath.row] as! String, contentMode: .scaleAspectFit)
        
    return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tabletitlearray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WikiViewController")
//        self.present(controller, animated: true, completion: nil)
//        var view1 = self.storyboard?.instantiateViewController(withIdentifier: "WikiViewController")
         urlstring = wikiarray[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
//        self.present(controller, animated: true, completion: nil)
        
    }
    
    //MARK: UISearchbar delegate
  
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Tabletitlearray = []
        Tabledescriptionarray = []
        Tableimagearray = []
        wikiarray = []
        addparameters(type: searchbar.text!)
        request()
    }
    
func addparameters(type:String)
    {

        
url = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages|pageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10&gpssearch="
        
        if ft == 0
        {
            url = url! + type
            ft == 1
        }
        else
        {
            url = url! + " + " + type
            
        }
        
    
        
    }
    
     func request()
    {
        
        let escapedString = url?.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        
        let urll = URL(string: escapedString!)
        //Create request with caching policy
        let request = URLRequest(url: urll!, cachePolicy: NSURLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60)
        
        //Get cache response using request object
        let cacheResponse = URLCache.shared.cachedResponse(for: request)
        
        //check if cached response is available if nil then hit url for data
        if cacheResponse == nil {
            
            //default configuration
            let config = URLSessionConfiguration.default
            
            //Enable url cache in session configuration and assign capacity
            config.urlCache = URLCache.shared
            config.urlCache = URLCache(memoryCapacity: 51200, diskCapacity: 10000, diskPath: "urlCache")
            
            //create session with configration
            let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
            
            //create data task to download data and having completion handler
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                //below two lines will cache the data, request object as key
                let cacheResponse = CachedURLResponse(response: response!, data: data!)
                URLCache.shared.storeCachedResponse(cacheResponse, for: request)
                
                do {
                    
                    if let todoJSON = try JSONSerialization.jsonObject(with: cacheResponse.data, options: []) as? [String: Any]{
//                        print(todoJSON)
                        
                        
                       if let result = todoJSON["query"] as? [String:Any]
                       {
                        var result1 = (result["pages"]) as? [Any]
                        
                        for page in result1!
                        {
                            var result2 = page as! [String:Any]
                            
                            
                            if let imageresult1 = result2["thumbnail"] as? [String:Any]
                            {
                                var imageresult2 = imageresult1["source"] as! String
                                //    var imageresult3 = imageresult2[0] as String
                                Tableimagearray.append(imageresult2)
                                
                            }
                            else
                            {
                                
                                Tableimagearray.append("")
                                
                            }
                            
                            if let titleresult1 = result2["title"] as? String
                            {
                                
                                Tabletitlearray.append(titleresult1)
                                 wikiarray.append( "https://en.wikipedia.org/wiki/\(titleresult1)")
                            }
                            else
                            {
                                 wikiarray.append("")
                                Tabletitlearray.append("")
                                
                            }
                            
                            if let descriptionresult1 = result2["terms"] as? [String:Any]
                            {
                                var descriptionresult2 = descriptionresult1["description"] as! [String]
                                var descriptionresult3 = descriptionresult2[0] as String
                                Tabledescriptionarray.append(descriptionresult3)
                                
                            }
                            else
                            {
                                
                                Tabledescriptionarray.append("")
                                
                            }
                            

                            
                            
                        }
                            print(Tableimagearray)
                        }
                        
                        
                        
                    }
                    
                    DispatchQueue.main.async {
                       
                        self.tablevieww.reloadData()
                    }
                    
                }
                    
                catch {
                    
                    print("error")
                }
                
                
            })
            task.resume()
        } else {
            //if cache response is not nil then print
            let string = NSString(data: cacheResponse!.data, encoding: String.Encoding.utf8.rawValue)
            
            
            do {
                
                if let todoJSON = try JSONSerialization.jsonObject(with: (cacheResponse?.data)!, options: []) as? [String: Any]{
//                    print(todoJSON)
                    
                    
                    if let result = todoJSON["query"] as? [String:Any]
                    {
                        var result1 = (result["pages"]) as? [Any]
                        
                        for page in result1!
                        {
                            var result2 = page as! [String:Any]
                            
                            
                            if let imageresult1 = result2["thumbnail"] as? [String:Any]
                            {
                                var imageresult2 = imageresult1["source"] as! String
                                //    var imageresult3 = imageresult2[0] as String
                                Tableimagearray.append(imageresult2)
                                
                            }
                            else
                            {
                                
                            Tableimagearray.append("")
                                
                            }
                                
                                
                            
                            if let titleresult1 = result2["title"] as? String
                            {
                                
                                Tabletitlearray.append(titleresult1)
                                wikiarray.append( "https://en.wikipedia.org/wiki/\(titleresult1)")
                               
                                
                            }
                            else
                            {
                                
                                Tabletitlearray.append("")
                                 wikiarray.append( "")
                                
                            }
                            
                            if let descriptionresult1 = result2["terms"] as? [String:Any]
                            {
                                var descriptionresult2 = descriptionresult1["description"] as! [String]
                                var descriptionresult3 = descriptionresult2[0] as String
                                Tabledescriptionarray.append(descriptionresult3)
                                
                            }
                            else
                            {
                                
                                Tabledescriptionarray.append("")
                                
                            }
                            
                          
                            
                        }
                        print(Tableimagearray)
                        
                    }
                    
                    
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.tablevieww.reloadData()
                }
                
            }

            catch
            {
                print("error")
                return
            }
            
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        print(url)
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            print(image)
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

