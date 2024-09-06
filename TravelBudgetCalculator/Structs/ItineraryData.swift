//
//  ItineraryData.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import Foundation

/*
 - USD：144.93円
 - ARA：0.15円
 - COP：0.035円
 - MXN：7.28円
 */

let defaultItineraryData: [DailyExpense] = [
    // USA
    DailyExpense(date: "9月12日（木）", cityName: "LosAngeles 1日目", currency: .USD, expenseData: []),
    
    // (Only Flight)
    // ※パナマではUSドル
    DailyExpense(date: "9月13日（金）", cityName: "Panama空港~BuenosAires空港", currency: .USD, expenseData: []),
    
    // Argentina
    DailyExpense(date: "9月14日（金）", cityName: "BuenosAires 1日目", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月15日（土）", cityName: "BuenosAires 2日目", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月16日（日）", cityName: "BuenosAires 3日目", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月17日（月）", cityName: "Patagonia 1日目（El Chalten宿泊）", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月18日（火）", cityName: "Patagonia 2日目（Fiz Royキャンプ）", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月19日（水）", cityName: "Patagonia 3日目（El Calafate宿泊）", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月20日（金）", cityName: "BuenosAires 4日目", currency: .ARA, expenseData: []),
    DailyExpense(date: "9月21日（土）", cityName: "BuenosAires 5日目", currency: .ARA, expenseData: []),
    
    // Colombia
    DailyExpense(date: "9月22日（日）", cityName: "Bogota 1日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月23日（月）", cityName: "Bogota 2日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月24日（火）", cityName: "Medellin 1日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月25日（水）", cityName: "Medellin 2日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月26日（木）", cityName: "Medellin 3日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月27日（金）", cityName: "Medellin 4日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月28日（土）", cityName: "Medellin 5日目", currency: .COP, expenseData: []),
    DailyExpense(date: "9月29日（日）", cityName: "Medellin 6日目", currency: .COP, expenseData: []),
    
    // Mexico
    DailyExpense(date: "9月30日（月）", cityName: "MexicoCity 1日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月1日（火）", cityName: "Guanajuato 1日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月2日（水）", cityName: "Guanajuato 2日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月3日（木）", cityName: "Guanajuato 3日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月4日（金）", cityName: "MexicoCity 2日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月5日（土）", cityName: "MexicoCity 3日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月6日（日）", cityName: "MexicoCity 4日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月7日（月）", cityName: "MexicoCity 5日目", currency: .MXN, expenseData: []),
    DailyExpense(date: "10月8日（火）", cityName: "MexicoCity 6日目", currency: .MXN, expenseData: []),
    
    // (Only Flight)
    DailyExpense(date: "10月9日（火）", cityName: "LA空港から東京に移動", currency: .USD, expenseData: [])
]
