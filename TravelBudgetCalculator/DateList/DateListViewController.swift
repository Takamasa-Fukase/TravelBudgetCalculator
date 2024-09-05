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

extension DateListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let data = data[indexPath.row].expenseData
//        var paymentItemCount = 0
//        data.forEach({ item in
//            paymentItemCount += item.items.count
//        })
//        // 48 + 64 + (24,28,12)
//        /*
//         １つの日付に対して最低でも最初からあって消えないものは、
//         3つのジャンルのヘッダーとフッター。
//         なので、48(header), 64(footer) x 3は最初からある。
//         それに加えて、3つのジャンルのitemの合計数。
//         */
//        let eachGenreHeaderFooterSumHeight = 3 * (48 + 64)
//        let allItemsInDaySumHeight = paymentItemCount * (24 + 28 + 12)
//        return CGFloat(eachGenreHeaderFooterSumHeight + allItemsInDaySumHeight) + 200
//    }
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
        cell.didUpdateData = { [weak self] newData in
            self?.data[indexPath.row].expenseData = newData
            print("\(indexPath.row + 1)日目がdidUpdateData")
            print("データ: \(self?.data)")
            self?.tableView.reloadData()
        }
        return cell
    }
}
