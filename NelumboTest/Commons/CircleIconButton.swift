//
//  CircleIconButton.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class CircleIconButton: UIControl {
    private let imageView = UIImageView()

    init(systemName: String) {
        super.init(frame: .zero)
        backgroundColor = .systemPurple
        layer.cornerRadius = 28
        clipsToBounds = true

        imageView.image = UIImage(systemName: systemName)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 56),
            heightAnchor.constraint(equalToConstant: 56),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
