//
//  RegularCollectionViewController.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/14.
//

import Foundation

struct ImageLabelItem {
    var imageName: String
    var label: String
    
    init(_ imageName: String, _ label: String) {
        self.imageName = imageName
        self.label = label
    }
}

struct RegularCVConstants {
    static let sectionVerticalInset = 10
    static let sectionHoriontalInset = 10
    static let column: Int = 3
    static let lineSpace = 10
    static let itemSpace = 10
}

@objc
class RegularCollectionViewController : UIViewController {
    private var collectionView: UICollectionView!
    private var dataList: [ImageLabelItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Regular CollectionView"
//        self.view.backgroundColor = .green
        
        dataList = [ImageLabelItem("AppIcon", "AppIcon"), ImageLabelItem("TabItemDevice", "TabItemDevice")
                    , ImageLabelItem("TabItemInfo", "TabItemInfo"), ImageLabelItem("TabItemList", "TabItemList")
                    , ImageLabelItem("TabItemSwift", "TabItemSwift")]
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
//        flowLayout.itemSize = CGSize(width: 200, height: 100)
//        flowLayout.minimumLineSpacing = margin
//        flowLayout.minimumInteritemSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: CGFloat(RegularCVConstants.sectionVerticalInset)
                , left: CGFloat(RegularCVConstants.sectionHoriontalInset)
                , bottom: CGFloat(RegularCVConstants.sectionVerticalInset)
                , right: CGFloat(RegularCVConstants.sectionHoriontalInset))
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

extension RegularCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.size.width - (CGFloat(RegularCVConstants.column - 1)) * CGFloat(RegularCVConstants.itemSpace)
                - CGFloat(RegularCVConstants.sectionHoriontalInset) * 2
        ) / CGFloat(RegularCVConstants.column);
        let intItemWidth = NSInteger(itemWidth)
        return CGSize(width: intItemWidth, height: intItemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(RegularCVConstants.lineSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(RegularCVConstants.itemSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemData = dataList[indexPath.row]
        print("collectionView didSelectItem indexPath=\(indexPath) title=\(itemData.label)")
    }
}

extension RegularCollectionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
//        cell.backgroundColor = UIColor(red: CGFloat(arc4random() % 256) / 256.0, green: CGFloat(arc4random() % 256) / 256.0, blue: CGFloat(arc4random() % 256) / 256.0, alpha: 1)
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageLabelCell", for: indexPath) as! ImageLabelCell
        let itemData = dataList[indexPath.row]
        cell.imageView.image = .init(named: itemData.imageName)
        cell.textLabel.text = itemData.label;
        return cell;
    }

//     返回追加视图对象，供 UICollectionView 加载
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: BaseHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! BaseHeaderView
            headerView.textLabel.text = "Header_\(indexPath.section)"
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footerView: BaseFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath) as! BaseFooterView
            footerView.textLabel.text = "Footer\(indexPath.section)"
            return footerView
        }
        
        return UICollectionReusableView()
    }
    
    // 返回追加视图尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
    
    // 返回Header尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
}

