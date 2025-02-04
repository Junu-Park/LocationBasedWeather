//
//  ImageCollectionView.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import UIKit

import SnapKit

final class ImageCollectionView: UICollectionView {
    
    init(layout: UICollectionViewFlowLayout) {
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.id)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
