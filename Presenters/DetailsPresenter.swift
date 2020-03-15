//
//  DetailsPresenter.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
class DetailsPresnter: IDetailsPresenter {
    
    
    
    
   
    
    var detailsView : IDetailsView

    init(withDetailsView detailsView : IDetailsView) {
        
        
        self.detailsView = detailsView
        
    }
    
    func getReviews(movieId:String) {
        
        detailsView.showLoading()
        let detailsModel = DetailsModel(presenterRef:self)
        detailsModel.getReviews(query: movieId)
    }
    
    func onSuccess(reviews: [MovieReview]) {
        
        detailsView.hideLoading()
        detailsView.renderDetailsWithReviews(reviews: reviews)
    }
    
    func onFail(errorMessgae: String) {
        
        detailsView.hideLoading()
        detailsView.showErrorMessage(errorMessage: errorMessgae)
    }
    
    
    
    
}
