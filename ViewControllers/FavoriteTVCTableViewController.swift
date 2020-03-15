//
//  FavoriteTVCTableViewController.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/8/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteTVCTableViewController: UITableViewController {
    let coreDataModel:MoviesCoreDataModel=MoviesCoreDataModel()
    var FavArray=[Movies]()
    let coreDataObj:MoviesCoreDataModel=MoviesCoreDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="Favorite"
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FavArray=coreDataModel.getFavMovies()
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if FavArray.count<=0{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "You Don't Add Any Movie To Favorite,Yet💔"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.adjustsFontSizeToFitWidth = true

            noDataLabel.numberOfLines=0
            noDataLabel.font = UIFont(name: "Heiti TC", size: 25)
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        else{
            tableView.backgroundView  = nil

        }


        return FavArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let img:UIImageView=cell.viewWithTag(1) as! UIImageView
        let lab:UILabel=cell.viewWithTag(2) as! UILabel
        lab.text=FavArray[indexPath.row].title
        img.sd_imageIndicator=SDWebImageActivityIndicator.whiteLarge
        let photoUrlString = FavArray[indexPath.row].image ?? ""
        let photoUrl = URL(string: photoUrlString)
         img.sd_imageTransition = .fade
         img.sd_setImage(with: photoUrl,placeholderImage:UIImage(named: "place.png"))
        
        
        
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        let detailsPage:DetailsVC=self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsVC
         detailsPage.recievedMovie=FavArray[indexPath.row]
               navigationController?.pushViewController(detailsPage, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
        
        //in yes
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                       let ok = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                    
                    if self.coreDataObj.deleteSingleFavItem(movieId: self.FavArray[indexPath.row].id){
                                   self.FavArray.remove(at: indexPath.row)
                                  tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                                  
                                  
                              }
                
                
               })
               

             let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in

        
               
        
        }
               
               dialogMessage.addAction(ok)
               dialogMessage.addAction(cancel)
               
               self.present(dialogMessage, animated: true, completion: nil)

       
    }

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
                      if UIApplication.shared.statusBarOrientation.isLandscape {
                       
                        return 140.0
                          
                          
                          
                      }
                      else {

                     return 140.0
               
           }
           
        
        
        
        
        
        
    }
    
    
    
}
