//
//  DateListViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 31/8/24.
//

import UIKit

struct DailyExpense {
    let date: String
    let cityName: String
    var expenseData: [PaymentListSection]
}

class DateListViewController: UIViewController {
    var data: [DailyExpense] = [
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

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "DateListCell", bundle: nil), forCellReuseIdentifier: "DateListCell")
    }
}

extension DateListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateListCell", for: indexPath) as! DateListCell
        let item = data[indexPath.row]
        cell.dateLabel.text = item.date
        cell.cityNameLabel.text = item.cityName
        cell.data = item.expenseData
        cell.didUpdateCellHeight = { [weak self] in
//            self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        }
        return cell
    }
}
