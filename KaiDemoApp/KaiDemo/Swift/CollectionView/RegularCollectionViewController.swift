////
////  RegularCollectionViewController.swift
////  KaiDemo
////
////  Created by KaiKai on 2023/6/14.
////
//
//import Foundation
//
//class RegularCollectionViewController : UIViewController {
//    fileprivate var collectionView : UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Regular CollectionView"
//
//        let flowLayout = UICollectionViewFlowLayout()
//        let margin: CGFloat = 20
//        let section: CGFloat = 15
//        flowLayout.minimumLineSpacing = margin
//        flowLayout.minimumInteritemSpacing = margin
//        flowLayout.sectionInset = UIEdgeInsets(top: section, left: margin, bottom: section, right: margin)
//        flowLayout.scrollDirection = .vertical
//        flowLayout.sectionHeadersPinToVisibleBounds = true
//        flowLayout.sectionFootersPinToVisibleBounds = true
//
//        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: flowLayout)
//        // 注册 Cell
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
//        // 注册头部视图
//        collectionView.register(BaseHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
//        // 注册尾部视图
//        collectionView.register(BaseFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        self.view.addSubview(collectionView)
//
//    }
//
//}
