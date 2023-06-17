//
// Created by KaiKai on 2023/6/15.
//

import Foundation

class ImageLabelCell : UICollectionViewCell {
    internal var imageView: UIImageView!
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        addSubview(imageView)
        
        textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textAlignment = .center
        addSubview(textLabel)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let pSize = bounds.size
        imageView.frame = CGRect(x: pSize.width / 4, y: 8, width: pSize.width / 2, height: pSize.width / 2)
        textLabel.frame = CGRect(x: 10, y: CGRectGetMaxY(imageView.frame) + 8, width: pSize.width - 20, height: 24)
    }
}
