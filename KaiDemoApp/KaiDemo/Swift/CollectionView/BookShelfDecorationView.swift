//
//  BookDecorationView.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/18.
//

import UIKit

class BookShelfDecorationView: UICollectionReusableView {
    
    fileprivate var bg_imageView = UIImageView()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bg_imageView.image = UIImage(named: "bookshelf")
        self.addSubview(bg_imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bg_imageView.frame = bounds
    }
    
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//
//    }
}
