
//
//  test.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/4/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import UIKit

class DataSource: UITableViewController{
    
 var reviewsArr = [MovieReview]()
  
     
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath)
        
        let autherlab:UILabel = cell.viewWithTag(1)as!UILabel
        let contentlab:UILabel = cell.viewWithTag(2)as!UILabel
        autherlab.text=reviewsArr[indexPath.row].author
         contentlab.text=reviewsArr[indexPath.row].content

        
        
        
        
        
        return cell
    }
    


func numberOfSectionsInTableView(tableView: UITableView) -> Int {
   
    
    
    
    
    return 1
    
    
    
    
    
   
}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewsArr.count<=0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Reviews Available 😐"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.adjustsFontSizeToFitWidth = true

            noDataLabel.numberOfLines=0
            noDataLabel.font = UIFont(name: "Heiti TC", size: 40)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        else{
                   tableView.backgroundView  = nil

               }
        
        return reviewsArr.count;
}

   
      
}


