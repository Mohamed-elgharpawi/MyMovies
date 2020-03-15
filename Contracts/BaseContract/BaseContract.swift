//
//  BaseContract.swift
//  MyMovies
//
//  Created by mohamed elgharpawi on 2/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
protocol IBaseView {
    
    func showLoading()
    func hideLoading()
    func showErrorMessage(errorMessage : String)
    func showAlert()
   
}

