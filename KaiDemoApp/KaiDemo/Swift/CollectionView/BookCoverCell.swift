//
//  BookCoverCell.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/18.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    private var coverImage: UIImageView!
    
    var imageName: String = "" {
        didSet {
            coverImage.image = UIImage(named: imageName)
        }
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        coverImage = UIImageView()
        contentView.addSubview(coverImage)
        backgroundColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
