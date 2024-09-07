//
//  DailyExpense.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import Foundation

struct DailyExpense: Codable {
    let date: String
    var cityName: String
    var currency: CurrencyType
    var expenseData: [PaymentListSection]
}
