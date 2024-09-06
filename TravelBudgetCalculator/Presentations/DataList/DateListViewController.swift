//
//  DateListViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import UIKit
import Parchment

class DateListViewController: UIViewController {
    var pagingViewController = PagingViewController(viewControllers: [])
    var dateList: [DailyExpense] = []
    
    var isLatinAmerica = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLatinAmerica {
            // 初期データを取り込み
            dateList = defaultItineraryData
            // 各日に３ジャンルの初期データを挿入
            dateList.enumerated().forEach { (index, dailyExpense) in
                if dailyExpense.expenseData.isEmpty {
                    print("ジャンルデータが入っていないのでデフォルトデータを挿入しました: \(dailyExpense.date), \(dailyExpense.cityName)")
                    dateList[index].expenseData = [
                        .init(paymentType: .transportation, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: dailyExpense.currency)
                        ]),
                        .init(paymentType: .food, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: dailyExpense.currency)
                        ]),
                        .init(paymentType: .other, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: dailyExpense.currency)
                        ])
                    ]
                }
            }
        }
        
        setupParchment()
    }

    func setupParchment() {
        let vcs = dateList.map { dailyExpense in
            let sb = UIStoryboard(name: "DateDetailViewController", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! DateDetailViewController
            vc.dailyExpense = dailyExpense
            vc.title = dailyExpense.date
            return vc
        }
        
        pagingViewController = PagingViewController(viewControllers: vcs)
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.textColor = .systemGray
        pagingViewController.selectedTextColor = .label
        pagingViewController.menuBackgroundColor = .systemBackground
        pagingViewController.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        pagingViewController.indicatorOptions = .visible(height: 4, zIndex: Int.max - 1, spacing: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        // 最初に表示するページを設定
//        pagingViewController.select(index: vcs.count - 1)
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pagingViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
