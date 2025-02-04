//
//  ImageCollectionViewCell.swift
//  LocationBasedWeather
//
//  Created by 박준우 on 2/4/25.
//

import UIKit

import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "ImageCollectionViewCell"
    
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
