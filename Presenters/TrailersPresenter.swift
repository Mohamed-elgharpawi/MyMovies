//
//  TrailersPresenter.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
class TrailerPresnter: ITrailerPresenter {
    
    
    
    
    
   
    
    var trailersView : ITrailerView

    init(withTrailerView trailersView : ITrailerView) {
        
        
        self.trailersView = trailersView
        
    }
    func getTrailers(movieId: String) {
        //trailersView.showLoading()
        let trailerModel = TrailerModel(presenterRef: self)
        trailerModel.getTrailers(query: movieId)
        
    }
    
   
    func onSuccess(trailers: [MovieTrailer]) {
        
        trailersView.hideLoading()
        trailersView.renderDetailsWithTrailer(trailer: trailers)
    }
    
    func onFail(errorMessgae: String) {
        
    trailersView.hideLoading()
        trailersView.showErrorMessage(errorMessage: errorMessgae)
    }
    
    
    
    
}
