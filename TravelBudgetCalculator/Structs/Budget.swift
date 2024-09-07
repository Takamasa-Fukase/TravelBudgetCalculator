//
//  Budget.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import Foundation

struct Budget: Codable {
    var name: String
    var budgetAmount: Double
    var targetDates: [DailyExpense]
}
