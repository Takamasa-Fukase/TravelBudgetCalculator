//
//  TopViewController.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Travel {
    let name: String
    let duration: String
    let image: UIImage?
    let dateList: [DailyExpense]
}

class TopViewController: UIViewController {
    let disposeBag = DisposeBag()
    // TODO: 後でUDの直参照にしたら消す
    var travels: [Travel] = [
        .init(name: "Latin America", duration: "9月12日〜10月10日", image: UIImage(named: "latin_america"), dateList: [])
    ]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toRateSettingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        toRateSettingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "RateSettingViewController", bundle: nil).instantiateInitialViewController() as! RateSettingViewController
                self.navigationController?.pushViewController(vc, animated: true)
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
    
    func setNaviBarRightButton() {
        
    }
}

extension TopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var editedData = UserDefaults.registeredCurrencies
        let selectedCurrency = editedData[indexPath.row]
        
        // 確認アラートを出す
        let alert = UIAlertController(title: "旅行を削除します", message: "本当によろしいですか？", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let delete = UIAlertAction(title: "削除", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            // TODO: 旅行の記録に使用されている通貨は削除できないようにしたい（データが消えると困るので）
            
//            editedData.remove(at: indexPath.row)
//            UserDefaults.registeredCurrencies = editedData
//            self.tableView.deleteRows(at: [indexPath], with: .left)
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
//        return UserDefaults.registeredCurrencies.count
        return travels.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelListCell", for: indexPath) as! TravelListCell
//        let item = UserDefaults.registeredCurrencies[indexPath.row]
        let item = travels[indexPath.row]
        cell.travelNameLabel.text = item.name
        cell.durationLabel.text = item.duration
        cell.backgroundImageView.image = item.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "DateListViewController", bundle: nil).instantiateInitialViewController() as! DateListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
