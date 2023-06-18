//
//  WaterCollectionView.sw  ift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/17.
//

import UIKit

@objc
class WaterCollectionViewController : UIViewController {
    private var collectionView: UICollectionView!
    private var dataList: [ImageLabelItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = .green
        
        let tmpDataList = [ImageLabelItem("AppIcon", "AppIcon"), ImageLabelItem("TabItemDevice", "TabItemDevice")
                           , ImageLabelItem("TabItemInfo", "TabItemInfo"), ImageLabelItem("TabItemList", "TabItemList")
                           , ImageLabelItem("TabItemSwift", "TabItemSwift")]
        dataList = []
        for _ in 1...5 {
            dataList.append(contentsOf: tmpDataList)
        }
        
        let flowLayout = WaterFallFlowLayout()
        flowLayout.delegate = self
        flowLayout.cols = 3
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10 //CGFloat(RegularCVConstants.sectionVerticalInset)
                , left: 10 //CGFloat(RegularCVConstants.sectionHoriontalInset)
                , bottom: 100 //CGFloat(RegularCVConstants.sectionVerticalInset)
                , right: 10 //CGFloat(RegularCVConstants.sectionHoriontalInset)
        )
//        flowLayout.sectionHeadersPinToVisibleBounds = true
//        flowLayout.sectionFootersPinToVisibleBounds = true
        
        let collectionFrame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView.register(ImageLabelCell.self, forCellWithReuseIdentifier: "ImageLabelCell")
        collectionView.register(BaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(BaseFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
}

//extension RegularCollectionViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 返回 cell 尺寸
//        return CGSize(width: 80, height: 120)
//    }
//}

extension WaterCollectionViewController : WaterFallLayoutDelegate {
    func waterFlowLayout(_ waterFlowLayout: WaterFallFlowLayout, itemHeight indexPath: IndexPath) -> CGFloat {
        let itemWidth = (collectionView.bounds.size.width - (CGFloat(RegularCVConstants.column - 1)) * CGFloat(RegularCVConstants.itemSpace)
                - CGFloat(RegularCVConstants.sectionHoriontalInset) * 2
        ) / CGFloat(RegularCVConstants.column);
        
        var floatItemWidth = Float(itemWidth);
//        if (indexPath.row % 2 == 0) {
        floatItemWidth *= Float.random(in: 1..<2)
//        }
        var intItemWidth = NSInteger(floatItemWidth)
        return CGFloat(intItemWidth)
    }
}

extension WaterCollectionViewController : UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let itemWidth = (collectionView.bounds.size.width - (CGFloat(RegularCVConstants.column - 1)) * CGFloat(RegularCVConstants.itemSpace)
////                - CGFloat(RegularCVConstants.sectionHoriontalInset) * 2
////        ) / CGFloat(RegularCVConstants.column);
////        var intItemWidth = NSInteger(itemWidth)
////        if (indexPath.row % 2 == 0) {
////            intItemWidth /= 2
////        }
////        return CGSize(width: intItemWidth, height: intItemWidth)
//        return CGSizeZero
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        CGFloat(RegularCVConstants.lineSpace)
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        CGFloat(RegularCVConstants.itemSpace)
//        return 0
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = dataList[indexPath.row]
        print("collectionView didSelectItem indexPath=\(indexPath) title=\(itemData.label)")
    }
}

extension WaterCollectionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelCell", for: indexPath) as! ImageLabelCell
        let itemData = dataList[indexPath.row]
        cell.imageView.image = .init(named: itemData.imageName)
        cell.textLabel.text = itemData.label;
        return cell;
    }
}

