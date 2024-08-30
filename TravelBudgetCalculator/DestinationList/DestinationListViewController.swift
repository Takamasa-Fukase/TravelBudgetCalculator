//
//  DestinationListViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import UIKit

struct Destination {
    let name: String
    let duration: String
    let sum: Double
    let yosan: Double
    let currency: CurrencyType
}

class DestinationListViewController: UIViewController {
    var destinationList: [Destination] = [
        .init(name: "バリ島", duration: "7/18~7/23", sum: 9.1, yosan: 10.6, currency: .IDR),
        .init(name: "インド", duration: "7/24~7/29", sum: 9.7, yosan: 9.4, currency: .INR),
        .init(name: "トルコ", duration: "7/30~8/3", sum: 10.2, yosan: 8.1, currency: .TRY),
    ]
    
    @IBOutlet weak var createDestinationButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var yosanLabel: UILabel!
    @IBOutlet weak var restAmount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "DestinationListCell", bundle: nil), forCellReuseIdentifier: "DestinationListCell")
    }
}

extension DestinationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: その目的地の日付一覧画面に遷移
    }
}

extension DestinationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationListCell", for: indexPath) as! DestinationListCell
        let item = destinationList[indexPath.row]
        cell.nameLabel.text = item.name
        cell.durationLabel.text = item.duration
        return cell
    }
}
