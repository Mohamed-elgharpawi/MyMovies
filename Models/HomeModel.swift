//
//  HomeModel.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import Alamofire
import Reachability
import SwiftyJSON

class HomeModel {
    
    
    var presenterProto : IHomePresenter
    init(presenterRef : IHomePresenter) {
        self.presenterProto = presenterRef
    }
    
    func getMovies(query:String,sortby:String) {
        var url:URL?=nil
        //http://api.themoviedb.org/3/discover/movie?sort_by=popularity.%20desc&api_key=b1b4dff13bd7f4d3012c38dab715678c
        if sortby == ""{
             url = URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.%20desc&api_key=b1b4dff13bd7f4d3012c38dab715678c&page=\(query)")
            
        }
        else{
           url = URL(string: "https://api.themoviedb.org/3/movie/\(sortby)?api_key=b1b4dff13bd7f4d3012c38dab715678c&page=\(query)")
            
        }
        
        
        
        var  movArr:[Movies] = Array()
           //var dict:Dictionary<String,Any>?
        AF.request(url!).validate().responseJSON { response in
          //print(response)
//
//              let x = response.value
//              if(response.response!.statusCode != 200){
//                  self.presenterProto.onFail(errorMessgae: "RESPONSE ERROR")
//
//              }
//              //print(x!)
//
//              dict=x as? Dictionary<String,Any>
//
//            if let result:NSArray = dict?["results"] as? NSArray{
//
//              for item in result{
//
//            if let d:Dictionary<String, Any> = item as? Dictionary<String, Any>{
//                let id = d["id"] as! Int
//                print("test ID \(id)")
//            let title=d["title"] as? String ?? ""
//            var poster_url:String = "https://image.tmdb.org/t/p/w500//"
//             poster_url.append(d["poster_path"] as? String ?? "")
//             //print(poster_url)
//              let reating=d["vote_average"] as? Float ?? 0.0
//                print("-----\(reating)")
//                let relase_Year=d["release_date"] as? String ?? "Date unavailable"
//                print(relase_Year)
//              let overview=d["overview"] as? String ?? "unavailable"
//
//
//           movArr.append(Movies(Id: String(id), Title: title, Image: poster_url, Rating: reating, ReleaseDate: relase_Year,  Overview: overview))
//
//
//
//                }
//
//
//
//
//                              }
            
            let json = JSON(response.data as Any)
                       
                        
    for item in json["results"].arrayValue {
                               
        let title = item["title"].stringValue
        print("TITLE CHECK\(title)")
                                
        var image = "https://image.tmdb.org/t/p/w500//"
        image.append(item["poster_path"].stringValue)
                                
        let release_date = item["release_date"].stringValue
        let rating = item["vote_average"].floatValue
               
        let id = item["id"].stringValue
        let overview = item["overview"].stringValue
        let popularity = item["popularity"].floatValue
         print("rating\(popularity)")
        let movie = Movies(Id: id, Title: title, Image: image, Rating: rating, ReleaseDate: release_date, Overview: overview,Popularity: popularity)
                                
                                movArr.append(movie)
                            }
            
          self.presenterProto.onSuccess(movies: movArr)
        }
          

              

        }
        
        
        
     
        
        
    
    
    func getMoviesCoreData(Sort: String) {
            
   let coreData:MoviesCoreDataModel=MoviesCoreDataModel()
   
             
        self.presenterProto.onSuccess(movies : coreData.getMoviesFromCore(sortby: Sort))
        }
}
    
    
   
    
    

