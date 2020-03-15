//
//  DetailsModel.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import Alamofire
import Reachability
import SwiftyJSON

class DetailsModel{
    var presenterProto : IDetailsPresenter
    init(presenterRef : IDetailsPresenter) {
        self.presenterProto = presenterRef
    }

    
   
    func getReviews(query:String){
        
        
       
        
       let url = URL(string: "https://api.themoviedb.org/3/movie/\(query)/reviews?api_key=b1b4dff13bd7f4d3012c38dab715678c&language=en-US&page=1")
        
        
        var  reviewsArr:[MovieReview] = Array()
        AF.request(url!).validate().responseJSON { response in
        
            let json = JSON(response.data as Any)

              for item in json["results"].arrayValue{
              
                let id = item["id"].stringValue
                let author=item["author"].stringValue
                let content=item["content"].stringValue
             print("GAAAAATTT\(author)")
             
                                     
              
           reviewsArr.append(MovieReview( ID: id, Author: author, Content: content))
                
                print("Appended")
                
                }
              
                
              self.presenterProto.onSuccess(reviews: reviewsArr)

              
                              }
            }
              

        

        
        
        
    
}
