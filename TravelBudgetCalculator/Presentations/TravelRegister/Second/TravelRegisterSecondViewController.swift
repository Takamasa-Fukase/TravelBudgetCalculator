//
//  TravelRegisterSecondViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit

class TravelRegisterSecondViewController: UIViewController {
    var travel: Travel = .init(name: "", duration: "", imageData: nil, dateList: [])
    
    @IBOutlet weak var tableView: TouchesBeganTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "旅行を登録"
    }
}

extension TravelRegisterSecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel.dateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return UITableViewCell()
    }
}
