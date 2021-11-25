//
//  SLTMainTableViewController.swift
//  Solity Demo
//
//  Created by Solity 013 on 2021/11/25.
//

import UIKit

class SLTMainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellIdentifier = "com.SolityChina.BaiduMapDemo.SLTMainTableViewCell"
    var titles: [Dictionary<NSString, NSString>]?
    var images: [NSString]?
    var secondaryTitles: [[Dictionary<NSString, NSString>]]?
    
    //MARK:View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        configUI()
    }
    
    //MARK:Config UI
    func configUI() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = COLOR(0xFFFFFF)
        title = "Solity Demo"
        view.addSubview(tableView)
    }
    
    //MARK:Config title
    func setupTitle() {
        titles = [["百度地图（SLTMapDetailViewController）":"定位、地图语言、选择位置"]]
        images = ["createMapView"]
    }
    
    //MARK:UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SLTMainTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SLTMainTableViewCell
        cell.refreshUIWithData(titles! as NSArray, images! as NSArray, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC =  SLTMapDetailViewController()
        let subtitleDictionary: NSDictionary = titles![indexPath.row] as NSDictionary
        let subtitleArray: NSArray = subtitleDictionary.allValues as NSArray
        detailVC.title = subtitleArray.firstObject as? String
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.title = ""
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    //MARK:Lazy loading
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame:CGRect(x:0, y:0, width:KScreenWidth, height:KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue), style:UITableView.Style.plain)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.register(SLTMainTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
}
