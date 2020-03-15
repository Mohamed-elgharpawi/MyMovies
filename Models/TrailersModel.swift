//
//  TrailersModel.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrailerModel {
    
     var presenterProto : ITrailerPresenter
       init(presenterRef : ITrailerPresenter) {
           self.presenterProto = presenterRef
       }

    func getTrailers(query:String){
                
                
               
                
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(query)/videos?api_key=b1b4dff13bd7f4d3012c38dab715678c&language=en-US&page=1")
                
                
                var  trailerArr:[MovieTrailer] = Array()
                AF.request(url!).validate().responseJSON { response in

                    let json = JSON(response.data as Any)

                      for item in json["results"].arrayValue{
                     
                      
                   
                        let id = item["id"].stringValue
                        let key=item["key"].stringValue
                    
        
                     
                                             
                      
                   trailerArr.append(MovieTrailer( ID: id, KEY:key))
                        print("Appended")
                        
                        }
                      
                        self.presenterProto.onSuccess(trailers: trailerArr)

                      
                      
                                      }
                    }
                      
                }
      

                
                
                
                
            
    




