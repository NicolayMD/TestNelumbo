//
//  NotificationBellView.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 10/08/25.
//

import UIKit

final class NotificationBellView: UIView {
    
    private let bellButton = UIButton(type: .custom)
    private let badgeLabel = UILabel()
    
    var onTap: (() -> Void)?
    
    init(badgeCount: Int = 0) {
        super.init(frame: .zero)
        setupUI()
        setBadge(count: badgeCount)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        let bellImage = UIImage(systemName: "bell.fill")
        bellButton.setImage(bellImage, for: .normal)
        bellButton.tintColor = .white
        bellButton.addTarget(self, action: #selector(tapBell), for: .touchUpInside)
        
        badgeLabel.textColor = .white
        badgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.backgroundColor = .systemRed
        badgeLabel.layer.cornerRadius = 9
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bellButton.addSubview(badgeLabel)
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: bellButton.topAnchor, constant: -4),
            badgeLabel.trailingAnchor.constraint(equalTo: bellButton.trailingAnchor, constant: 4),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            badgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        bellButton.frame = CGRect(x: -30, y: -10, width: 30, height: 30)
        addSubview(bellButton)
    }
    
    func setBadge(count: Int) {
        badgeLabel.text = "\(count)"
        badgeLabel.isHidden = (count == 0)
    }
    
    @objc private func tapBell() {
        onTap?()
    }
}
