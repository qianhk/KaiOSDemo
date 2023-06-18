//
//  DecorationCollectionViewController.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/18.
//

import UIKit

@objc
class DecorationCollectionViewController : UIViewController {
    
    private var collectionView: UICollectionView!
    private let maxNum: Int = 4
    private var mockData = [[String]]()
    private var prevIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Book Shelf"
        mockData = [["1", "2", "3"]
                    , ["4", "5", "6", "7"]
                    , ["8", "9", "10"]
                    , ["11", "22", "33"]
                    , ["44", "55"]
                    , ["66", "77", "88", "99"]
                    , ["100", "11"]]
        
        let flowLayout = DecorationFlowLayout()
        let margin: CGFloat = 20
        let section: CGFloat = 15
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: section, left: margin, bottom: section, right: margin)
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 80, height: 120)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: "BookCoverCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch (gesture.state) {
        case .began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            prevIndexPath = selectedIndexPath
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            if let moveIndexPath: IndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) {
                if prevIndexPath == moveIndexPath {
                    collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                } else {
                    // 判断书架是否放满 kai:貌似不对,一个section超过3本书就无法拖动了
                    if collectionView.numberOfItems(inSection: moveIndexPath.section) < 4 {
                        collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                    } else {
                        break
                    }
                }
            }
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension DecorationCollectionViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 80, height: 120)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView didSelectItem indexPath=\(indexPath) content=\(mockData[indexPath.section][indexPath.row])")
    }
}

extension DecorationCollectionViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCoverCell", for: indexPath) as! BookCoverCell
        cell.imageName = mockData[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let book = mockData[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        mockData[destinationIndexPath.section].insert(book, at: (destinationIndexPath as NSIndexPath).row)
    }
}

