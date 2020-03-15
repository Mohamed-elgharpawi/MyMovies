//
//  DetailsContract.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
protocol IDetailsView : IBaseView {
    
    func renderDetailsWithReviews(reviews : [MovieReview]);
    
    
}


protocol IDetailsPresenter {
    
    func getReviews(movieId:String)

    func onSuccess(reviews:[MovieReview])
    func onFail(errorMessgae : String)
}


protocol IDetailsManager {
    
    func getReviews(detailsPresenter : IDetailsPresenter)
    
}
