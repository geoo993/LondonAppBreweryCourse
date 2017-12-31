//
//  BitcoinViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AppCore

class BitcoinViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    // where to get http request https://apiv2.bitcoinaverage.com/#ticker-data-per-symbol
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR",
                         "GBP","HKD","IDR","ILS","INR",
                         "JPY","MXN","NOK","NZD","PLN",
                         "RON","RUB","SEK","SGD","USD",
                         "ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", 
                               "£", "$", "Rp", "₪", "₹", 
                               "¥", "$", "kr", "$", "zł", 
                               "lei", "₽", "kr", "$", "$", "R"]
    var selectedRow = 0
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(row, currencySymbolArray[row], currencyArray[row])
        selectedRow = row
        let finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL)
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { [weak self] response in
                guard let this = self else { return }
                if response.result.isSuccess {

                    //print("Success! Got the weather data")
                    if let json = response.result.value {
                        let bitcoinJSON : JSON = JSON(json)
                        //print("JSON: \(bitcoinJSON)") 
                        this.updateBitCoinData(json: bitcoinJSON)
                    }
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    this.bitcoinPriceLabel.text = "Connection Issues"
                }
                
            }

    }

    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitCoinData(json : JSON) {
        if let priceValue = json["last"].double {
            let price = currencySymbolArray[selectedRow] + " \(priceValue)"
            let font = price.getFontSize(fromFont: bitcoinPriceLabel.font, 
                                         inFrame: bitcoinPriceLabel.frame, 
                                         desiredFontSize: 54,
                                         reduceBy: 2)
            bitcoinPriceLabel.font = font
            bitcoinPriceLabel.text = price
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }
    

}

