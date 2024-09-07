//
//  BudgetRegisterViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 7/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class BudgetRegisterViewController: UIViewController {
    let disposeBag = DisposeBag()
    var travel: Travel = .init(id: UUID(), name: "", duration: "", dateList: [], budgetList: [])
    var section1Titles: [String] = ["予算名", "予算金額"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "予算を登録"
        setupTableView()
        
        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let selectedIndexPaths = self.tableView.indexPathsForSelectedRows?.filter({ $0.section == 1 }) ?? []
                
            }).disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "BudgetRegisterInputFormCell", bundle: nil), forCellReuseIdentifier: "BudgetRegisterInputFormCell")
        tableView.register(UINib(nibName: "BudgetRegisterDateListCell", bundle: nil), forCellReuseIdentifier: "BudgetRegisterDateListCell")
        tableView.register(UINib(nibName: "BudgetRegisterDateListSectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "BudgetRegisterDateListSectionHeader")
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 200
    }
}

extension BudgetRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BudgetRegisterDateListSectionHeader") as! BudgetRegisterDateListSectionHeader
            return sectionHeader
        }else {
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return travel.dateList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }else {
            return 36
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetRegisterInputFormCell", for: indexPath) as! BudgetRegisterInputFormCell
            let title = section1Titles[indexPath.row]
            cell.titleLabel.text = title
            cell.textField.placeholder = title
            
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BudgetRegisterDateListCell", for: indexPath) as! BudgetRegisterDateListCell
            let item = travel.dateList[indexPath.row]
            cell.dateLabel.text = item.date
            cell.cityNameLabel.text = item.cityName
            
            return cell
        }
    }
}
