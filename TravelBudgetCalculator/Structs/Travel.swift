//
//  Travel.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit

struct Travel: Codable {
    var id: UUID
    var name: String
    var duration: String
    var imageData: Data?
    var dateList: [DailyExpense]
    var budgetList: [Budget]
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
}
