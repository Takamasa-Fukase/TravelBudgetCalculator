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

    @IBOutlet weak var toDateListButton: UIButton!
    @IBOutlet weak var toRateSettingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDateListButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "DateListViewController", bundle: nil).instantiateInitialViewController() as! DateListViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        toRateSettingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {return}
                let vc = UIStoryboard(name: "RateSettingViewController", bundle: nil).instantiateInitialViewController() as! RateSettingViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
}
