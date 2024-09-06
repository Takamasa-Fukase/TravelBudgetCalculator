//
//  RegisteredCurrency.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import Foundation

struct RegisteredCurrency: Codable {
    let type: CurrencyType
    var toYenRate: Double
}
