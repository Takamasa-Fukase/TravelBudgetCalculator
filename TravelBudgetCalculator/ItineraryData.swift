//
//  ItineraryData.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import Foundation

var defaultItineraryData: [DailyExpense] = [
    DailyExpense(date: "9月12日", cityName: "ロサンゼルス1日目", expenseData: [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]),
    DailyExpense(date: "9月13日", cityName: "ブエノスアイレス1日目", expenseData: [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]),
    DailyExpense(date: "9月14日", cityName: "ブエノスアイレス2日目", expenseData: [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]),
    DailyExpense(date: "9月15日", cityName: "ブエノスアイレス3日目", expenseData: [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]),
    DailyExpense(date: "9月16日", cityName: "パタゴニア1日目（El Chalten宿泊）", expenseData: [
        PaymentListSection(
            paymentType: .transportation,
            items: []
        ),
        PaymentListSection(
            paymentType: .food,
            items: []
        ),
        PaymentListSection(
            paymentType: .other,
            items: []
        )
    ]),
]
