//
//  TravelListCell.swift
//  TravelBudgetCalculator
//
//  Created by ウルトラ深瀬 on 6/9/24.
//

import UIKit

class TravelListCell: UITableViewCell {
    let gradationLayer = CAGradientLayer()

    @IBOutlet weak var travelNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradationView: UIView!
    @IBOutlet weak var highlightView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGradationView()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradationLayer.frame = gradationView.bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            highlightView.backgroundColor = .systemGray.withAlphaComponent(0.5)
        }else {
            highlightView.backgroundColor = .clear
        }
    }
    
    private func setupGradationView() {
        let topColor = UIColor.clear
        let bottomColor = UIColor.systemBackground.withAlphaComponent(0.8)
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        gradationLayer.colors = gradientColors
        gradationView.layer.insertSublayer(gradationLayer, at: 0)
    }
}
