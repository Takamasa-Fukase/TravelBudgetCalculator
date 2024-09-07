//
//  TopViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

class TopViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createDefaultLatinAmericaTravelButton: UIButton!
    @IBOutlet weak var toRateSettingButton: UIButton!
    @IBOutlet weak var toTravelRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        createDefaultLatinAmericaTravelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                
                // デフォルトデータを取り込み
                var dateList = defaultItineraryData
                
                // 各日の通貨に合わせて３ジャンルの出費データの初期値を生成
                dateList.enumerated().forEach({ (index, item) in
                    dateList[index].expenseData = [
                        .init(paymentType: .transportation, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ]),
                        .init(paymentType: .food, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ]),
                        .init(paymentType: .other, items: [
                            .init(id: UUID(), title: "", amount: 0, currencyType: item.currency)
                        ])
                    ]
                })
                let travel = Travel(
                    id: UUID(),
                    name: "Latin America",
                    duration: "\(dateList.first?.date ?? "")〜\(dateList.last?.date ?? "")",
                    imageData: UIImage(named: "latin_america")!.pngData()!,
                    dateList: dateList,
                    budgetList: [
                        .init(
                            name: "全体",
                            budgetAmount: 100000,
                            targetDates: dateList
                        )
                    ]
                )
                
                UserDefaults.travels = UserDefaults.travels + [travel]
                self.tableView.reloadData()
                
            }).disposed(by: disposeBag)
        
        toRateSettingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "RateSettingViewController", bundle: nil).instantiateInitialViewController() as! RateSettingViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        toTravelRegisterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "TravelRegisterFirstViewController", bundle: nil).instantiateInitialViewController() as! TravelRegisterFirstViewController
                vc.delegate = self
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .pageSheet
                self.present(navi, animated: true)
            }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dismissCellHighlight(tableView: tableView)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "TravelListCell", bundle: nil), forCellReuseIdentifier: "TravelListCell")
        tableView.contentInset.bottom = 200
    }
}

extension TopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var editedData = UserDefaults.travels
        
        // 確認アラートを出す
        let alert = UIAlertController(title: "旅行を削除します", message: "本当によろしいですか？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let delete = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            editedData.remove(at: indexPath.row)
            UserDefaults.travels = editedData
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}

extension TopViewController: UITableViewDataSource, UITabBarDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaults.travels.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelListCell", for: indexPath) as! TravelListCell
        let item = UserDefaults.travels[indexPath.row]
        cell.travelNameLabel.text = item.name
        cell.durationLabel.text = item.duration
        if let image = item.image {
            cell.backgroundImageView.image = image
        }else {
            cell.backgroundImageView.image = UIImage(systemName: "airplane.departure")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "DateListViewController", bundle: nil).instantiateInitialViewController() as! DateListViewController
        let travel = UserDefaults.travels[indexPath.row]
        vc.title = travel.name
        vc.travelId = travel.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopViewController: TravelRegisterDelegate {
    func onRegistered() {
        tableView.reloadData()
    }
}
