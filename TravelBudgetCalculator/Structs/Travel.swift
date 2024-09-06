//
//  Travel.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit

struct Travel: Codable {
    let name: String
    let duration: String
    let imageData: Data?
    let dateList: [DailyExpense]
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
}
