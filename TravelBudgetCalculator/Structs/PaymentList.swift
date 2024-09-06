//
//  PaymentList.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import Foundation

struct PaymentListSection: Codable {
    let paymentType: PaymentType
    var items: [PaymentListItem]
    
    enum PaymentType: String, CaseIterable, Codable {
        case transportation = "交通費"
        case food = "食費"
        case other = "その他"
    }
}

struct PaymentListItem: Codable {
    let id: UUID
    var title: String
    var amount: Double
    var currencyType: CurrencyType
}
