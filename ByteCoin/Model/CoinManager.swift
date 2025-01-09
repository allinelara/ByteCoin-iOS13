//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func didUpdateCoin(_ coinManager: CoinManager, coinModel: CoinModel)
    func didFailWithError( error: Error)
}

struct CoinManager {
    
    var delegate : CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "D3D08B5C-8DE0-46BA-B0C7-D3EAB8DFF95F"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice (for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

        performeRequest(with: urlString)
    }

    
    func performeRequest( with urlString: String){
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task =  session.dataTask(with: url) { (data, response, error) in
                
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = parseJSON(coin: safeData){
                        self.delegate?.didUpdateCoin(self, coinModel: coin)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON ( coin : Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coin)
            let rate = decodeData.rate
            let currency = decodeData.asset_id_quote
            print(rate)
            let coin = CoinModel(rate: rate, currency: currency)
            
            return coin
            
            
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
