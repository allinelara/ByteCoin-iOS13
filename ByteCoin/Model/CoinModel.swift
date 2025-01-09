//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Alline de Lara on 09.01.25.
//  Copyright © 2025 The App Brewery. All rights reserved.
//


import Foundation

struct CoinModel {
    let rate: Double
    let currency: String
    
    var rateString: String{
        return String(format: "%.1f", rate)
    }
}
