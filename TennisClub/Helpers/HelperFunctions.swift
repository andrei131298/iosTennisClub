//
//  HelperFunctions.swift
//  TennisClub
//
//  Created by user191625 on 3/29/21.
//

import Foundation

func convertToCurrency(_ number: Double) -> String{
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    
    return priceString
}
