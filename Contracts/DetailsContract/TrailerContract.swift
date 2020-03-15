//
//  TrailerContract.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 3/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
protocol ITrailerView : IBaseView {
func renderDetailsWithTrailer(trailer : [MovieTrailer]);
}
protocol ITrailerPresenter {
    
   
    func getTrailers(movieId:String)

    func onSuccess(trailers:[MovieTrailer])
    func onFail(errorMessgae : String)
}
protocol ITrailerManager {
    
    func getTrailers(trailerPresenter : ITrailerPresenter)
    
}
