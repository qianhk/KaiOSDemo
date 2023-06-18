//
//  SwiftDemoEntryViewController.swift
//  KaiDemo
//
//  Created by KaiKai on 2023/6/18.
//

import UIKit

struct EntryInfoItem {
    var name: String
    var vc: UIViewController.Type
    
    init(_ name: String, vc: UIViewController.Type) {
        self.name = name
        self.vc = vc
    }
}

@objc
public class SwiftDemoEntryViewController : UITableViewController {
    
    private var dataList: [EntryInfoItem] = [];
    
    override public func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Kai Swift Demo" // 在这儿会覆盖底部tabbar上的名称
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .orange
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DemoTextTableViewCell")
        
        dataList.append(EntryInfoItem("BMI", vc: BMIViewController.self))
        dataList.append(EntryInfoItem("Regular CollectionView", vc: RegularCollectionViewController.self))
        dataList.append(EntryInfoItem("Water CollectionView", vc: WaterCollectionViewController.self))
        dataList.append(EntryInfoItem("Decoration CollectionView", vc: DecorationCollectionViewController.self))
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item = dataList[indexPath.row]
//        let vc = item.vc as! UIViewController.Type
        let vcInstance = item.vc.init()
        self.navigationController?.pushViewController(vcInstance, animated: true)
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataList.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DemoTextTableViewCell", for: indexPath)
        cell.textLabel?.text = dataList[indexPath.row].name
        return cell
    }
}
