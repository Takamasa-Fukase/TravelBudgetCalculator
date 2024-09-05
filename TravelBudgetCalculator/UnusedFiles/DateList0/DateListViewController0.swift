////
////  DateListViewController0.swift
////  TravelBudgetCalculator
////
////  Created by ウルトラ深瀬 on 31/8/24.
////
//
//import UIKit
//
//struct DailyExpense {
//    let date: String
//    let cityName: String
//    var expenseData: [PaymentListSection]
//}
//
//class DateListViewController0: UIViewController {
//    var data: [DailyExpense] = [
//        DailyExpense(date: "9月12日", cityName: "ロサンゼルス1日目", expenseData: [
//            PaymentListSection(
//                paymentType: .transportation,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .food,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .other,
//                items: []
//            )
//        ]),
//        DailyExpense(date: "9月13日", cityName: "ブエノスアイレス1日目", expenseData: [
//            PaymentListSection(
//                paymentType: .transportation,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .food,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .other,
//                items: []
//            )
//        ]),
//        DailyExpense(date: "9月14日", cityName: "ブエノスアイレス2日目", expenseData: [
//            PaymentListSection(
//                paymentType: .transportation,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .food,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .other,
//                items: []
//            )
//        ]),
//        DailyExpense(date: "9月15日", cityName: "ブエノスアイレス3日目", expenseData: [
//            PaymentListSection(
//                paymentType: .transportation,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .food,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .other,
//                items: []
//            )
//        ]),
//        DailyExpense(date: "9月16日", cityName: "パタゴニア1日目（El Chalten宿泊）", expenseData: [
//            PaymentListSection(
//                paymentType: .transportation,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .food,
//                items: []
//            ),
//            PaymentListSection(
//                paymentType: .other,
//                items: []
//            )
//        ]),
//    ]
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//    }
//    
//    func setupTableView() {
//        tableView.register(UINib(nibName: "DateListCell", bundle: nil), forCellReuseIdentifier: "DateListCell")
//        tableView.reloadData()
//    }
//}
//
//extension DateListViewController0: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 500
//    }
//}
//
//extension DateListViewController0: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DateListCell", for: indexPath) as! DateListCell
//        let item = data[indexPath.row]
//        cell.dateLabel.text = item.date
//        cell.cityNameLabel.text = item.cityName
//        cell.data = item.expenseData
//        cell.addButtonTapped = { [weak self] genreIndex in
//            self?.data[indexPath.row].expenseData[genreIndex].items.append(
//                PaymentListItem(title: "⭐️", amount: 0.0, currencyType: .ARA)
//            )
//            self?.tableView.reloadData()
//        }
//        cell.tableView.reloadData()
//        // TODO: 200追加して雑にバグFixしている
//        cell.tableViewHeight.constant = cell.tableView.contentSize.height + 200
//        return cell
//    }
//}
