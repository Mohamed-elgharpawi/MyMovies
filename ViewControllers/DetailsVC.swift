//
//  DetailsVC.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class DetailsVC: UITableViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var overviewLab: UILabel!
    var recievedMovie:Movies!
    @IBOutlet weak var reviewsTable: UITableView!
    @IBOutlet weak var trailerCollection: UICollectionView!
    @IBOutlet weak var favBtn: UIButton!
    var dataSource = DataSource()
    var traillerDS=TrailerCollection()
    var reviewsArray = [MovieReview]()
    var trailerArray = [MovieTrailer]()
    let coreDataModel:MoviesCoreDataModel = MoviesCoreDataModel()

    //var networkActivity : UIActivityIndicatorView?
  let activityView = UIActivityIndicatorView(style: .whiteLarge)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewsTable.delegate=dataSource
        reviewsTable.dataSource=dataSource
        trailerCollection.dataSource=traillerDS
        trailerCollection.delegate=traillerDS

        
       
        let detailsPresenter = DetailsPresnter(withDetailsView: self )
        let trailerPresenter = TrailerPresnter(withTrailerView : self as ITrailerView )
        
        detailsPresenter.getReviews(movieId:recievedMovie.id!)
        trailerPresenter.getTrailers(movieId: recievedMovie.id!)
        self.tableView.rowHeight = UITableView.automaticDimension
        
        tableView.estimatedRowHeight=500
        reviewsTable.rowHeight = UITableView.automaticDimension

        movieTitle.text=recievedMovie!.title!
//        imgV.sd_imageIndicator=SDWebImageActivityIndicator.grayLarge
//
//        imgV.sd_setImage(with: URL(string: recievedMovie.image!
//       ))
        

             imgV.sd_imageIndicator=SDWebImageActivityIndicator.whiteLarge

               
               let photoUrlString = recievedMovie.image ?? ""

               let photoUrl = URL(string: photoUrlString)

               imgV.sd_imageTransition = .fade
                imgV.sd_setImage(with: photoUrl,placeholderImage:UIImage(named: "place.png"))
               
        rating.settings.fillMode = .precise
        rating.settings.updateOnTouch=false
        rating.rating=Double((recievedMovie.rating/2.0))
        overviewLab.text=recievedMovie.overview!
        dateLab.text=recievedMovie.releaseDate

        if coreDataModel.checkExistence(searchId: recievedMovie.id!, entityName: "Favorite")
        {
            favBtn.setImage(UIImage(named: "like.png"), for: UIControl.State.normal)
            favBtn.isEnabled=false

          
         
         }
       

    }
    @IBAction func addToFav(_ sender: Any) {
         
        if coreDataModel.saveFavMovies(movie: recievedMovie)
        {
            
            favBtn.setImage(UIImage(named: "like.png"), for: UIControl.State.normal)
            favBtn.isEnabled=false
        }
        
        
        
           
       }

    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    



    
}


extension DetailsVC : ITrailerView{
    func showAlert() {
        
    }
    
    func renderDetailsWithTrailer(trailer: [MovieTrailer]) {
        trailerArray = trailer

        traillerDS.trailerArr=trailer
        coreDataModel.saveTrailers(trailerArray: trailerArray, movieId: recievedMovie.id!)
        self.trailerCollection.reloadData()    }
    
    
    
    
}
extension DetailsVC:IDetailsView{
  
    
    
    
    

       
    func renderDetailsWithReviews(reviews: [MovieReview]) {
        reviewsArray = reviews
        dataSource.reviewsArr=reviewsArray
        coreDataModel.saveReviews(reviewsArray: reviewsArray, movieId: recievedMovie.id!)

        self.reviewsTable.reloadData()
    }
    
    func showLoading() {

        let container: UIView = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
        container.backgroundColor = .clear

      
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true

        container.addSubview(activityView)
        self.view.addSubview(container)
        activityView.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=true
        
    }
    
    func hideLoading() {

        print("Stop Detals Loading.....")
        activityView.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=false

    }
    
    func showErrorMessage(errorMessage: String) {
                print(errorMessage)
         activityView.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=false

    }
    
    
    
    
}


