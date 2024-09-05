//
//  DateListViewController2.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import UIKit
import Parchment

class DateListViewController2: UIViewController {
    var pagingViewController = PagingViewController(viewControllers: [])
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupParchment()
    }

    func setupParchment() {
        let vcs = data.map { dailyExpense in
            let sb = UIStoryboard(name: "DateDetailViewController", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! DateDetailViewController
            vc.date = dailyExpense.date
            vc.cityName = dailyExpense.cityName
            vc.data = dailyExpense.expenseData
            vc.title = dailyExpense.date
            return vc
        }
        
        pagingViewController = PagingViewController(viewControllers: vcs)
//        pagingViewController.menuItemSize = .sizeToFit(minWidth: 53, height: 37)
        pagingViewController.menuHorizontalAlignment = .center
//        pagingViewController.menuBackgroundColor = UIColor.kuraselLightGreenColor2
        pagingViewController.selectedTextColor = UIColor.black
        pagingViewController.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        pagingViewController.selectedFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
//        pagingViewController.indicatorColor = UIColor.kuraselGreenButtonColor
        pagingViewController.indicatorOptions = .visible(height: 4, zIndex: Int.max - 1, spacing: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        //        pagingViewController.borderOptions = .visible(height: 2, zIndex: Int.max - 1, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        pagingViewController.select(index: vcs.count - 1)
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        //フローティングボトムボタンを手前に表示する為
        view.sendSubviewToBack(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagingViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        pagingViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        pagingViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pagingViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}
