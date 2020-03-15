//
//  HomePresenter.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import Reachability
class HomePresnter: IHomePresenter {

    
   
    
    var homeView : IHomeView
   
    
    init(withHomeView homeView : IHomeView) {
        
        
        self.homeView = homeView
        
    }
    
    
    func getMovies(pageNum:String,sortby Sortby:String,networkState:Bool) {
        
        let reachability = try! Reachability()
               reachability.whenReachable = {
                     reachability in
                     
                   
                    print("From net")

                    self.homeView.showLoading()
                   let homeModel = HomeModel(presenterRef: self)
                   homeModel.getMovies(query: pageNum,sortby: Sortby)
                   
                   reachability.stopNotifier()

                  }
                  reachability.whenUnreachable = { _ in
                      print("Not reachable")
                    if(networkState == false){
                    print("From data")
                            let homeModel = HomeModel(presenterRef: self)
                            homeModel.getMoviesCoreData(Sort: Sortby)
                    }
                        reachability.stopNotifier()

                      
                  }

                  do {
                      try reachability.startNotifier()
                  } catch {
                      print("Unable to start notifier")
                  }


               
           }
           
           
        
        
      
        
    
    func onSuccess(movies: [Movies]) {
        
        homeView.hideLoading()
        homeView.renderHomeWithMovies(movies: movies)
    }
    
    func onFail(errorMessgae: String) {
        
        homeView.hideLoading()
        homeView.showErrorMessage(errorMessage: errorMessgae)
    }
    func onNoConnection() {
        homeView.hideLoading()

        homeView.showAlert()
    }
    
}
    
    
    
    

