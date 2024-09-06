//
//  PaymentList.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import Foundation

struct PaymentListSection {
    let paymentType: PaymentType
    var items: [PaymentListItem]
    
    enum PaymentType: String, CaseIterable {
        case transportation = "交通費"
        case food = "食費"
        case other = "その他"
    }
}

struct PaymentListItem {
    let id: UUID
    var title: String
    var amount: Double
    var currencyType: CurrencyType
}
