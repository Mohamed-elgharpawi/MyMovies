//
//  HomeContract.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
protocol IHomeView : IBaseView {
    
    func renderHomeWithMovies(movies : [Movies]);
    
    func gotoDetails(movie:Movies);
    
}


protocol IHomePresenter {
    
    func getMovies(pageNum:String,sortby:String,networkState:Bool)
    func onSuccess(movies : [Movies])
    func onFail(errorMessgae : String)
    func onNoConnection()

}


protocol IHomeManager {
    
    func getMovies(homePresenter : IHomePresenter)
    
}
