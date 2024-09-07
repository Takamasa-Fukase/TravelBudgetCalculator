//
//  DateListViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 5/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import Parchment

class DateListViewController: UIViewController {
    let disposeBag = DisposeBag()
    var pagingViewController = PagingViewController(viewControllers: [])
    var travelId: UUID = UUID()
    
    @IBOutlet weak var toBudgetComparisonButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupParchment()
        toBudgetComparisonButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "BudgetComparisonViewController", bundle: nil).instantiateInitialViewController() as! BudgetComparisonViewController
                vc.travelId = self.travelId
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }

    func setupParchment() {
        let dateList = UserDefaults.travels.first(where: { $0.id == travelId })?.dateList ?? []
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
