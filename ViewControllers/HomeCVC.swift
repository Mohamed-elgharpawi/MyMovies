//
//  AllMoviesCVC.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import SDWebImage
import iOSDropDown
import Reachability

private let reuseIdentifier = "Cell"

class HomeCVC: UICollectionViewController {
    
   
    @IBOutlet weak var sortDropDown: DropDown!
    var isLoading = false
    var loadingView: LoadingReusableView?
    let coreDataModel:MoviesCoreDataModel = MoviesCoreDataModel()

    var pagesCounter=1
    var selectedSort:String = ""
    var con:Bool=false
    var lastState:Bool=false
    var conIndicator:Bool=false


    var networkActivity : UIActivityIndicatorView?
    var moviesArray = [Movies]()
    var recentlyMoviesArray = [Movies]()
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
                   self.collectionView.reloadData()
                   
               }
               else {


        self.collectionView.reloadData()

               }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
       let homePresenter = HomePresnter(withHomeView: self)
        homePresenter.getMovies(pageNum: String(1),sortby: "",networkState:con)
        
        sortDropDown.optionArray = ["Default", "popular", "high-rated"]
        
        sortDropDown.optionIds = [1,2,3]
        
        
        
        
        
        //Location of core data
        print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))

        
        print("DEADLOAD")
        
               let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
               collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")
        
        
        self.title="Movies"
        
       checkConection()
       
    }
    
    

    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView  = nil

        DispatchQueue.global().async {
                       sleep(4)
        if self.moviesArray.count==0{
     
           
            
//            let width = UIScreen.main.bounds.size.width
//            let height = UIScreen.main.bounds.size.height
            DispatchQueue.main.async {
                
                
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
                           noDataLabel.text          = "No internet connection or cached data Tap to reload! 🛠"
                           noDataLabel.textColor     = UIColor.black
                           noDataLabel.adjustsFontSizeToFitWidth = true

                           noDataLabel.numberOfLines=0
                           noDataLabel.font = UIFont(name: "Arial Rounded MT", size: 35)
                           noDataLabel.textAlignment = .center
                           collectionView.backgroundView  = noDataLabel
              noDataLabel.isUserInteractionEnabled = true
                 let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.buttonClicked))
                
                noDataLabel.addGestureRecognizer(tapRecognizer)
            }
          
        
            


        }
        
        else{
             DispatchQueue.main.async {
            collectionView.backgroundView  = nil
            }
            }}
        return moviesArray.count
    }
    
    @objc func buttonClicked() {
        
        
        let homePresenter = HomePresnter(withHomeView: self)
               homePresenter.getMovies(pageNum: String(1),sortby: "",networkState:con)
        
        
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        let height = cell.frame.size.height
        let width = cell.frame.size.width
        let imgV:UIImageView = cell.viewWithTag(2)as!UIImageView
        imgV.frame.size = CGSize(width: width, height: height)

      imgV.sd_imageIndicator=SDWebImageActivityIndicator.whiteLarge

        
        let photoUrlString = moviesArray[indexPath.row].image ?? ""

        let photoUrl = URL(string: photoUrlString)

        imgV.sd_imageTransition = .fade
         imgV.sd_setImage(with: photoUrl,placeholderImage:UIImage(named: "place.png"))
        
        

        //Test Recdnt
        checkConection()
        if indexPath.row == moviesArray.count-2 && con==false
        {
            showAlert()
        }
        
        coreDataModel.saveMovies(movie:moviesArray[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        gotoDetails(movie: moviesArray[indexPath.row])
    }
  
  
    
    
    
    
    
}






extension HomeCVC:IHomeView{
    
    
    func gotoDetails(movie: Movies) {
        let detailsPage:DetailsVC=self.storyboard?.instantiateViewController(withIdentifier: "details") as! DetailsVC
        detailsPage.recievedMovie=movie
        navigationController?.pushViewController(detailsPage, animated: true)
        


        
    }
    
    func renderHomeWithMovies(movies: [Movies]) {
        
        recentlyMoviesArray=movies
        print("rendering")
        
        moviesArray.append(contentsOf: recentlyMoviesArray)
        
       
    }
    
    func showLoading() {
        
        print("Start Loading....")
        networkActivity = UIActivityIndicatorView(style:.whiteLarge)
        networkActivity?.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=true

    }
    
    func hideLoading() {
        networkActivity?.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=false
        
        print("Stop Loading.....")
        
        self.collectionView.reloadData()

    }
    
    func showErrorMessage(errorMessage: String) {
        
        networkActivity?.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible=false

        print("Stop Loading.....")
        
    }
    func showAlert() {
        UIApplication.shared.isNetworkActivityIndicatorVisible=false

        let alert = UIAlertController(title: "Connection Faild", message: "Note,there is no connection this data is from the previous usage", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        

        self.present(alert, animated: true)
       

    }
    
    
    
}
extension HomeCVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.size.height
        let width = view.frame.size.width
        if UIApplication.shared.statusBarOrientation.isLandscape {
            self.collectionView.reloadData()
            return CGSize(width: width * 0.4999, height: height * 0.85)
            
        }
        else {

          self.collectionView.reloadData()
            return CGSize(width: width * 0.4999, height: height * 0.24)
 

        }
            

        
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets.zero

    }
    
    
    
    
    
}

//scrolling is here
extension HomeCVC{
    
   
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
               checkConection()
               checkConection()
        
        
            if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading && con==true {
                DispatchQueue.global().async {
                    sleep(3)
                    if self.con==true  {
                       
                        self.loadMoreData()
                }
                
                }
                
                

                    
                
                
                
        }
        }
    
    func loadMoreData(){
        checkConection()
       
            if !self.isLoading && con==true {
                self.isLoading = true
                DispatchQueue.global().async {
                                       sleep(2)
                    if(self.pagesCounter<=500){
                    self.pagesCounter=self.pagesCounter+1
                        print("page counter \(self.pagesCounter)")
                     let homePresenter = HomePresnter(withHomeView: self)
                        homePresenter.getMovies(pageNum: String(self.pagesCounter), sortby: self.selectedSort,networkState:self.con)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        
       
        
    }
   
  
}

extension HomeCVC{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
           if self.isLoading {
               return CGSize.zero
           } else {
               return CGSize(width: collectionView.bounds.size.width, height: 55)
           }
       }
    
    

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            if kind == UICollectionView.elementKindSectionFooter {
                let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
                loadingView = aFooterView
                loadingView?.backgroundColor = UIColor.clear
                return aFooterView
            }
            return UICollectionReusableView()
        }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    
    
}
//sorting is Here
extension HomeCVC{
    override func viewDidAppear(_ animated: Bool) {
        if con==false{//showAlert()
            lastState=false
            
        }
       
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
           checkConection()

        
    sortDropDown.didSelect{(selectedText , index ,id) in
       
              self.checkConection()
            
              let homePresenter = HomePresnter(withHomeView: self)
        
        
               if index == 1{
                if self.selectedSort != "popular"{
                   self.pagesCounter=1
                self.moviesArray=Array()
                self.selectedSort="popular"
                    homePresenter.getMovies(pageNum: String(self.pagesCounter),sortby:"popular",networkState:self.con )
                 
                   self.collectionView.reloadData()
                }}
               if index == 2{
                  if self.selectedSort != "top_rated"{
                 self.pagesCounter=1
                self.selectedSort="top_rated"
                    self.moviesArray=Array()
                    homePresenter.getMovies(pageNum: String(self.pagesCounter),sortby: "top_rated",networkState:self.con)
                            
                                self.collectionView.reloadData()
                }}
               
               if index==0 {
                if self.selectedSort != ""{

                self.pagesCounter=1
                self.selectedSort=""
                    self.moviesArray=Array()
                    homePresenter.getMovies(pageNum: String(self.pagesCounter),sortby: "",networkState:self.con)
                            
                                self.collectionView.reloadData()
                   
                }}
        }
               
        }
           
    
    
        
   
    
}

extension HomeCVC{
    func checkConection (){
        
    
    let reachability = try! Reachability()
                  reachability.whenReachable = {
                        reachability in
                        
                      
                        self.con=true
                    self.conIndicator=true
                
                     reachability.stopNotifier()

                     }
                     reachability.whenUnreachable = { _ in
                         
                        self.con=false
                        self.conIndicator=false

                      reachability.stopNotifier()

                         
                     }

                     do {
                         try reachability.startNotifier()
                     } catch {
                         print("Unable to start notifier")
                     }


                  
    }
}
    
 
    
    

