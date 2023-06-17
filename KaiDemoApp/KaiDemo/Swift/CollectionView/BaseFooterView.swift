//
// Created by KaiKai on 2023/6/14.
//

import UIKit

class BaseFooterView : UICollectionReusableView {
    
    private var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: 20)
        textLabel.textAlignment = .center
        textLabel.text = "Footer"
        self.addSubview(textLabel)
        self.backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}