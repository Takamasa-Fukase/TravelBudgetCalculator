//
//  DailyExpense.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import Foundation

struct DailyExpense {
    let date: String
    let cityName: String
    let currency: CurrencyType
    var expenseData: [PaymentListSection]
}
